import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../lemma_sdk.dart';
import 'ad_containers.dart';

AdInstanceManager instanceManager = AdInstanceManager(
  'lemma_sdk',
);

class AdInstanceManager {
  final MethodChannel channel;
  int _nextAdId = 0;
  final _BiMap<int, Ad> _loadedAds = _BiMap<int, Ad>();

  AdInstanceManager(String channelName)
      : channel = MethodChannel(
          channelName,
          StandardMethodCodec(AdMessageCodec()),
        ) {
    channel.setMethodCallHandler((MethodCall call) async {
      assert(call.method == 'onAdEvent');

      final int adId = call.arguments['adId'];
      final String eventName = call.arguments['eventName'];

      final Ad? ad = adFor(adId);
      if (ad != null) {
        _onAdEvent(ad, eventName, call.arguments);
      } else {
        debugPrint('$Ad with id `$adId` is not available for $eventName.');
      }
    });
  }

  void _onAdEvent(Ad ad, String eventName, Map<dynamic, dynamic> arguments) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _onAdEventAndroid(ad, eventName, arguments);
    } else {
      _onAdEventIOS(ad, eventName, arguments);
    }
  }

  void _onAdEventAndroid(
      Ad ad, String eventName, Map<dynamic, dynamic> arguments) {
    switch (eventName) {
      case 'onAdLoaded':
        _invokeOnAdLoaded(ad, eventName, arguments);
        break;
      default:
        debugPrint('invalid ad event name: $eventName');
    }
  }

  void _onAdEventIOS(Ad ad, String eventName, Map<dynamic, dynamic> arguments) {
    switch (eventName) {
      case 'onAdLoaded':
        _invokeOnAdLoaded(ad, eventName, arguments);
        break;
      case 'onAdFailedToLoad':
        _invokeOnAdFailedToLoad(ad, eventName, arguments);
        break;
      case 'onBannerWillPresentScreen':
        _invokeOnAdOpened(ad, eventName);
        break;
      case 'onBannerDidDismissScreen':
        _invokeOnAdClosed(ad, eventName);
        break;
      case 'adWillPresent':
        _invokeOnAdShowingFullScreenContent(ad, eventName);
        break;
      case 'adDidDismiss':
        _invokeOnAdDismissedFullScreenContent(ad, eventName);
        break;

      default:
        debugPrint('invalid ad event name: $eventName');
    }
  }

  void _invokeOnAdShowingFullScreenContent(Ad ad, String eventName) {
    if (ad is InterstitialAd) {
      ad.fullScreenContentCallback?.onAdShowingFullScreenContent?.call(ad);
    } else {
      debugPrint('invalid ad: $ad, for event name: $eventName');
    }
  }

  void _invokeOnAdDismissedFullScreenContent(Ad ad, String eventName) {
    if (ad is InterstitialAd) {
      ad.fullScreenContentCallback?.onAdDismissedFullScreenContent?.call(ad);
    } else {
      debugPrint('invalid ad: $ad, for event name: $eventName');
    }
  }

  void _invokeOnAdOpened(Ad ad, String eventName) {
    if (ad is AdWithView) {
      ad.listener.onAdOpened?.call(ad);
    } else {
      debugPrint('invalid ad: $ad, for event name: $eventName');
    }
  }

  void _invokeOnAdClosed(Ad ad, String eventName) {
    if (ad is AdWithView) {
      ad.listener.onAdClosed?.call(ad);
    } else {
      debugPrint('invalid ad: $ad, for event name: $eventName');
    }
  }

  void _invokeOnAdFailedToLoad(
      Ad ad, String eventName, Map<dynamic, dynamic> arguments) {
    if (ad is AdWithView) {
      ad.listener.onAdFailedToLoad?.call(ad, arguments['loadAdError']);
    } else {
      debugPrint('invalid ad: $ad, for event name: $eventName');
    }
  }

  void _invokeOnAdLoaded(
      Ad ad, String eventName, Map<dynamic, dynamic> arguments) {
    ad.responseInfo = arguments['responseInfo'];
    if (ad is AdWithView) {
      ad.listener.onAdLoaded?.call(ad);
    }
    if (ad is InterstitialAd) {
      ad.adLoadCallback.onAdLoaded.call(ad);
    } else {
      debugPrint('invalid ad: $ad, for event name: $eventName');
    }
  }

  /// Returns null if an invalid [adId] was passed in.
  Ad? adFor(int adId) => _loadedAds[adId];

  /// Returns null if an invalid [Ad] was passed in.
  int? adIdFor(Ad ad) => _loadedAds.inverse[ad];

  final Set<int> _mountedWidgetAdIds = <int>{};

  /// Returns true if the [adId] is already mounted in a [WidgetAd].
  bool isWidgetAdIdMounted(int adId) => _mountedWidgetAdIds.contains(adId);

  /// Indicates that [adId] is mounted in widget tree.
  void mountWidgetAdId(int adId) => _mountedWidgetAdIds.add(adId);

  /// Indicates that [adId] is unmounted from the widget tree.
  void unmountWidgetAdId(int adId) => _mountedWidgetAdIds.remove(adId);

  /// Starts loading the ad if not previously loaded.
  ///
  /// Loading also terminates if ad is already in the process of loading.
  Future<void> loadBannerAd(BannerAd ad) {
    if (adIdFor(ad) != null) {
      return Future<void>.value();
    }

    final int adId = _nextAdId++;
    _loadedAds[adId] = ad;
    return channel.invokeMethod<void>(
      'loadBannerAd',
      <dynamic, dynamic>{
        'adId': adId,
        'request': ad.request,
        'size': ad.size,
      },
    );
  }

  Future<void> loadInterstitialAd(InterstitialAd ad) {
    if (adIdFor(ad) != null) {
      return Future<void>.value();
    }

    final int adId = _nextAdId++;
    _loadedAds[adId] = ad;
    return channel.invokeMethod<void>(
      'loadInterstitialAd',
      <dynamic, dynamic>{
        'adId': adId,
        'request': ad.request,
      },
    );
  }

  Future<String> getSDKVersion() async {
    return (await instanceManager.channel
        .invokeMethod<String>('LemmaSDK#version'))!;
  }

  Future<void> enableLogs(bool enabled) async {
    return (await instanceManager.channel
        .invokeMethod<void>('LemmaSDK#enableLogs', <dynamic, dynamic>{
      'enable': enabled,
    }));
  }

  Future<void> setAppDomain(String appDomain) async {
    return instanceManager.channel
        .invokeMethod<void>('LemmaSDK#setAppDomain', <dynamic, dynamic>{
      'appDomain': appDomain,
    });
  }

  Future<void> setStoreURL(String storeURL) async {
    return instanceManager.channel
        .invokeMethod<void>('LemmaSDK#setStoreURL', <dynamic, dynamic>{
      'storeURL': storeURL,
    });
  }

  Future<void> setAppCategories(String appCategories) async {
    return instanceManager.channel
        .invokeMethod<void>('LemmaSDK#setAppCategories', <dynamic, dynamic>{
      'appCategories': appCategories,
    });
  }

  Future<void> setAppKeywords(String appKeywords) async {
    return instanceManager.channel
        .invokeMethod<void>('LemmaSDK#setAppKeywords', <dynamic, dynamic>{
      'appKeywords': appKeywords,
    });
  }

  Future<void> setUserKeywords(String userKeywords) async {
    return instanceManager.channel
        .invokeMethod<void>('LemmaSDK#setUserKeywords', <dynamic, dynamic>{
      'userKeywords': userKeywords,
    });
  }

  Future<void> setCoppa(Bool coppa) async {
    return instanceManager.channel
        .invokeMethod<void>('LemmaSDK#setCoppa', <dynamic, dynamic>{
      'coppa': coppa,
    });
  }

  Future<void> setGDPR(Bool gdpr) async {
    return instanceManager.channel
        .invokeMethod<void>('LemmaSDK#setGDPR', <dynamic, dynamic>{
      'gdpr': gdpr,
    });
  }

  Future<void> setGDPRConsent(String gdprConsent) async {
    return instanceManager.channel
        .invokeMethod<void>('LemmaSDK#setGDPRConsent', <dynamic, dynamic>{
      'gdprConsent': gdprConsent,
    });
  }

  Future<void> setLocationParams(LocationParams location) async {
    return instanceManager.channel
        .invokeMethod<void>('LemmaSDK#setLocationParams', <dynamic, dynamic>{
      'LocationParams': location,
    });
  }

  /// Display an [AdWithoutView] that is overlaid on top of the application.
  Future<void> showAdWithoutView(AdWithoutView ad) {
    assert(
      adIdFor(ad) != null,
      '$Ad has not been loaded or has already been disposed.',
    );

    return channel.invokeMethod<void>(
      'showAdWithoutView',
      <dynamic, dynamic>{
        'adId': adIdFor(ad),
      },
    );
  }

  Future<AdSize> getAdSize(Ad ad) async {
    return (await instanceManager.channel.invokeMethod<AdSize>(
      'getAdSize',
      <dynamic, dynamic>{
        'adId': adIdFor(ad),
      },
    ))!;
  }

  Future<void> disposeAd(Ad ad) {
    final int? adId = adIdFor(ad);
    final Ad? disposedAd = _loadedAds.remove(adId);
    if (disposedAd == null) {
      return Future<void>.value();
    }
    return channel.invokeMethod<void>(
      'disposeAd',
      <dynamic, dynamic>{
        'adId': adId,
      },
    );
  }
}

class _BiMap<K extends Object, V extends Object> extends MapBase<K, V> {
  _BiMap() {
    _inverse = _BiMap<V, K>._inverse(this);
  }

  _BiMap._inverse(this._inverse);

  final Map<K, V> _map = <K, V>{};
  late _BiMap<V, K> _inverse;

  _BiMap<V, K> get inverse => _inverse;

  @override
  V? operator [](Object? key) => _map[key];

  @override
  void operator []=(K key, V value) {
    assert(!_map.containsKey(key));
    assert(!inverse.containsKey(value));
    _map[key] = value;
    inverse._map[value] = key;
  }

  @override
  void clear() {
    _map.clear();
    inverse._map.clear();
  }

  @override
  Iterable<K> get keys => _map.keys;

  @override
  V? remove(Object? key) {
    if (key == null) return null;
    final V? value = _map[key];
    inverse._map.remove(value);
    return _map.remove(key);
  }
}

class AdMessageCodec extends StandardMessageCodec {
  // The type values below must be consistent for each platform.
  static const int _valueAdSize = 128;
  static const int _valueAdRequest = 129;
  static const int _valueLoadAdError = 133;
  static const int _valueLocationParams = 147;

  @override
  void writeValue(WriteBuffer buffer, dynamic value) {
    if (value is AdRequest) {
      buffer.putUint8(_valueAdRequest);
      writeValue(buffer, value.publisherId);
      writeValue(buffer, value.adunitId);
      writeValue(buffer, value.serverURL);
      writeValue(buffer, value.netoworkTimeout);
      writeValue(buffer, value.switchToVideo);
    } else if (value is AdSize) {
      buffer.putUint8(_valueAdSize);
      writeValue(buffer, value.width);
      writeValue(buffer, value.height);
    } else if (value is LoadAdError) {
      buffer.putUint8(_valueLoadAdError);
      writeValue(buffer, value.code);
      writeValue(buffer, value.domain);
      writeValue(buffer, value.message);
    } else if (value is LocationParams) {
      buffer.putUint8(_valueLocationParams);
      writeValue(buffer, value.latitude);
      writeValue(buffer, value.longitude);
      writeValue(buffer, value.accuracy);
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  dynamic readValueOfType(dynamic type, ReadBuffer buffer) {
    switch (type) {
      case _valueAdSize:
        num width = readValueOfType(buffer.getUint8(), buffer);
        num height = readValueOfType(buffer.getUint8(), buffer);
        return AdSize(
          width: width.toInt(),
          height: height.toInt(),
        );
      case _valueAdRequest:
        return AdRequest(
          publisherId:
              readValueOfType(buffer.getUint8(), buffer)?.cast<String>(),
          adunitId: readValueOfType(buffer.getUint8(), buffer)?.cast<String>(),
          serverURL: readValueOfType(buffer.getUint8(), buffer)?.cast<String>(),
          netoworkTimeout:
              readValueOfType(buffer.getUint8(), buffer)?.cast<int>(),
        );
      case _valueLoadAdError:
        return LoadAdError(
          readValueOfType(buffer.getUint8(), buffer),
          readValueOfType(buffer.getUint8(), buffer),
          readValueOfType(buffer.getUint8(), buffer),
        );

      case _valueLocationParams:
        return LocationParams(
          latitude: readValueOfType(buffer.getUint8(), buffer),
          longitude: readValueOfType(buffer.getUint8(), buffer),
          accuracy: readValueOfType(buffer.getUint8(), buffer),
        );

      default:
        return super.readValueOfType(type, buffer);
    }
  }

  Map<String, List<T>>? _tryDeepMapCast<T>(Map<dynamic, dynamic>? map) {
    if (map == null) return null;
    return map.map<String, List<T>>(
      (dynamic key, dynamic value) => MapEntry<String, List<T>>(
        key,
        value?.cast<T>(),
      ),
    );
  }
}
