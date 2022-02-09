package com.example.lemma_sdk;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.StandardMethodCodec;
import lemma.lemmavideosdk.common.LMLog;
import lemma.lemmavideosdk.common.LemmaSDK;


/**
 * LemmaSdkPlugin
 */
public class LemmaSdkPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    @Nullable
    private FlutterPluginBinding pluginBinding;
    @Nullable
    private AdMessageCodec adMessageCodec;
    @Nullable
    private AdInstanceManager instanceManager;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
//    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "lemma_sdk");
//    channel.setMethodCallHandler(this);

        pluginBinding = binding;
        adMessageCodec = new AdMessageCodec(binding.getApplicationContext());

        channel =
                new MethodChannel(
                        binding.getBinaryMessenger(),
                        "lemma_sdk",
                        new StandardMethodCodec(adMessageCodec));
        channel.setMethodCallHandler(this);
        instanceManager = new AdInstanceManager(channel);
        binding
                .getPlatformViewRegistry()
                .registerViewFactory(
                        "plugins.flutter.io/lemma_sdk/ad_widget",
                        new LMAdsViewFactory(instanceManager));
        //instanceManager
//    appStateNotifier = new AppStateNotifier(binding.getBinaryMessenger());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (instanceManager == null || pluginBinding == null) {
//      Log.e(TAG, "method call received before instanceManager initialized: " + call.method);
            return;
        }
        // Use activity as context if available.
        Context context =
                (instanceManager.getActivity() != null)
                        ? instanceManager.getActivity()
                        : pluginBinding.getApplicationContext();
        switch (call.method) {

            case "_init":
                // Internal init. This is necessary to cleanup state on hot restart.
                instanceManager.disposeAllAds();
                result.success(null);
                break;

            case "LemmaSDK#version":
                // Internal init. This is necessary to cleanup state on hot restart.
                String ver = LemmaSDK.getVersion();
                result.success(ver);
                break;

            case "loadBannerAd":
                final FlutterBannerAd bannerAd =
                        new FlutterBannerAd(
                                call.<Integer>argument("adId"),
                                instanceManager,
                                call.<FlutterAdRequest>argument("request"),
                                call.<FlutterAdSize>argument("size"));
                bannerAd.setContext(context);
                instanceManager.trackAd(bannerAd, call.<Integer>argument("adId"));
                bannerAd.load();
                result.success(null);
                break;

            case "loadInterstitialAd":
                final FlutterInterstitialAd instlAd = new FlutterInterstitialAd(call.<Integer>argument("adId"),
                        instanceManager,
                        call.<FlutterAdRequest>argument("request"));
                instanceManager.trackAd(instlAd, call.<Integer>argument("adId"));
                instlAd.setContext(context);
                instlAd.load();
                result.success(null);
                break;

            case "showAdWithoutView":
                final boolean adShown = instanceManager.showAdWithId(call.<Integer>argument("adId"));
                if (!adShown) {
                    result.error("AdShowError", "Ad failed to show.", null);
                    break;
                }
                result.success(null);
                break;

            case "LemmaSDK#enableLogs":
                LMLog.setLogLevel(LMLog.LogLevel.All);
                break;

            case "LemmaSDK#setAppDomain":
            case "LemmaSDK#setStoreURL":
            case "LemmaSDK#setAppCategories":
            case "LemmaSDK#setAppKeywords":
            case "LemmaSDK#setUserKeywords":
            case "LemmaSDK#setCoppa":
            case "LemmaSDK#setGDPR":
            case "LemmaSDK#setGDPRConsent":
            case "LemmaSDK#setLocationParams":
//        result.success(null);
                result.notImplemented();
                break;

            default:
                result.notImplemented();
        }
    /*   if let dict = call.arguments as? Dictionary<String, AnyObject> {

                if let location = dict["LocationParams"] as? FLTLocationParams  {

                    LemmaSDK.shared().location = location.location()
                    }
            }
            result(nil)
        }
        else{
            result("iOS " + UIDevice.current.systemVersion)
        }
     */

//    if (call.method.equals("getPlatformVersion")) {
//      result.success("Android " + android.os.Build.VERSION.RELEASE);
//    } else {
//      result.notImplemented();
//    }
    }


    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {

    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        if (instanceManager != null) {
            instanceManager.setActivity(binding.getActivity());
        }
        if (adMessageCodec != null) {
            adMessageCodec.setContext(binding.getActivity());
        }
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        // Use the application context
        if (adMessageCodec != null && pluginBinding != null) {
            adMessageCodec.setContext(pluginBinding.getApplicationContext());
        }
        if (instanceManager != null) {
            instanceManager.setActivity(null);
        }
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        if (instanceManager != null) {
            instanceManager.setActivity(binding.getActivity());
        }
        if (adMessageCodec != null) {
            adMessageCodec.setContext(binding.getActivity());
        }
    }

    @Override
    public void onDetachedFromActivity() {
        if (adMessageCodec != null && pluginBinding != null) {
            adMessageCodec.setContext(pluginBinding.getApplicationContext());
        }
        if (instanceManager != null) {
            instanceManager.setActivity(null);
        }
    }

}
