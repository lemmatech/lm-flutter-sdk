import 'dart:async';
import 'dart:ffi';

import 'package:lemma_sdk/src/ad_instance_manager.dart';

export 'src/ad_containers.dart';
export 'src/ad_listeners.dart';

/// Location parameters that can be configured in an ad request.
class LocationParams {
  /// Location parameters that can be configured in an ad request.
  const LocationParams({
    required this.latitude,
    required this.longitude,
    this.accuracy,
  });

  /// The latitude in degrees.
  final double latitude;

  /// The longitude in degrees.
  final double longitude;

  /// The accuracy in meters.
  final double? accuracy;
}

class LemmaSDK {
  LemmaSDK._();

  static Future<String> version() {
    return instanceManager.getSDKVersion();
  }

  static Future<void> enableLogs(bool enabled) {
    return instanceManager.enableLogs(enabled);
  }

  static Future<void> setAppDomain(String appDomain) {
    return instanceManager.setAppDomain(appDomain);
  }

  static Future<void> setStoreURL(String storeURL) {
    return instanceManager.setStoreURL(storeURL);
  }

  static Future<void> setAppCategories(String cats) {
    return instanceManager.setAppCategories(cats);
  }

  static Future<void> setAppKeywords(String keywords) {
    return instanceManager.setAppKeywords(keywords);
  }

  static Future<void> setUserKeywords(String keywords) {
    return instanceManager.setUserKeywords(keywords);
  }

  static Future<void> setCoppa(Bool coppa) {
    return instanceManager.setCoppa(coppa);
  }

  static Future<void> setGDPR(Bool gdpr) {
    return instanceManager.setGDPR(gdpr);
  }

  static Future<void> setGDPRConsent(String gdprConsent) {
    return instanceManager.setGDPRConsent(gdprConsent);
  }

  static Future<void> setLocationParams(LocationParams location) {
    return instanceManager.setLocationParams(location);
  }
}
