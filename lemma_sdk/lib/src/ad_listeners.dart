import 'package:meta/meta.dart';

import 'ad_containers.dart';

typedef AdEventCallback = void Function(Ad ad);

/// The callback type to handle an error loading an [Ad].
typedef AdLoadErrorCallback = void Function(Ad ad, LoadAdError error);

/// Generic callback type for an event occurring on an Ad.
typedef GenericAdEventCallback<Ad> = void Function(Ad ad);

/// A callback type for when an error occurs loading a full screen ad.
typedef FullScreenAdLoadErrorCallback = void Function(LoadAdError error);

/// Callback events for for full screen ads, such as Rewarded and Interstitial.
class FullScreenContentCallback<Ad> {
  /// Construct a new [FullScreenContentCallback].
  ///
  /// [Ad.dispose] should be called from [onAdFailedToShowFullScreenContent]
  /// and [onAdDismissedFullScreenContent], in order to free up resources.
  const FullScreenContentCallback({
    this.onAdShowingFullScreenContent,
    this.onAdDismissedFullScreenContent,
  });

  /// Called when an ad shows full screen content.
  final GenericAdEventCallback<Ad>? onAdShowingFullScreenContent;

  /// Called when an ad dismisses full screen content.
  final GenericAdEventCallback<Ad>? onAdDismissedFullScreenContent;

}

abstract class AdWithViewListener {
  @protected
  const AdWithViewListener({
    this.onAdLoaded,
    this.onAdFailedToLoad,
    this.onAdOpened,
    this.onAdClosed,
  });

  /// Called when an ad is successfully received.
  final AdEventCallback? onAdLoaded;

  /// Called when an ad request failed.
  final AdLoadErrorCallback? onAdFailedToLoad;

  /// A full screen view/overlay is presented in response to the user clicking
  /// on an ad. You may want to pause animations and time sensitive
  /// interactions.
  final AdEventCallback? onAdOpened;

  /// Called when the full screen view has been closed. You should restart
  /// anything paused while handling onAdOpened.
  final AdEventCallback? onAdClosed;
}

class BannerAdListener extends AdWithViewListener {
  const BannerAdListener({
    AdEventCallback? onAdLoaded,
    AdLoadErrorCallback? onAdFailedToLoad,
    AdEventCallback? onAdOpened,
    AdEventCallback? onAdClosed,
  }) : super(
          onAdLoaded: onAdLoaded,
          onAdFailedToLoad: onAdFailedToLoad,
          onAdOpened: onAdOpened,
          onAdClosed: onAdClosed,
        );
}
