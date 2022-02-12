package com.example.lemma_sdk;

import android.content.Context;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.platform.PlatformView;
import lemma.lemmavideosdk.banner.LMBannerView;
import lemma.lemmavideosdk.bannervideo.LMInBannerVideo;

class FlutterBannerAd extends FlutterAd  {

    @NonNull private final AdInstanceManager manager;
    @NonNull private final FlutterAdSize size;
    @NonNull private final FlutterAdRequest request;
    @Nullable
    private LMBannerView adView;
    @Nullable
    private LMInBannerVideo inBannerAdView;

    public void setContext(Context context) {
        this.context = context;
    }

    private Context context;

    /** Constructs the FlutterBannerAd. */
    public FlutterBannerAd(
            int adId,
            @NonNull AdInstanceManager manager,
            @NonNull FlutterAdRequest request,
            @NonNull FlutterAdSize size) {
        super(adId);

        this.manager = manager;
        this.request = request;
        this.size = size;
    }

    @Override
    void load() {


        if (this.request.switchToVideo) {

            inBannerAdView = new LMInBannerVideo(context,
                    request.publisherId,
                    request.adUnitId,
                    new LMInBannerVideo.LMAdSize(size.width,size.height),
                    request.serverURL);

            inBannerAdView.setLayoutParams(new LinearLayout.LayoutParams(this.size.width,this.size.height));

            inBannerAdView.setListener(new LMInBannerVideo.InBannerVideoListener() {
                @Override
                public void onAdReceived(LMInBannerVideo inBannerAdView) {
                    if (adView != null) {
                        manager.onAdLoaded(adId);
                    }
                }

                @Override
                public void onAdFailed(LMInBannerVideo inBannerAdView, Error error) {
                    if (adView != null) {
                        FlutterAdError adErr = new FlutterAdError(1,"LemmaSDK",error.getMessage());
                        manager.onAdFailedToLoad(adId, adErr);
                    }
                }

                @Override
                public void onAdOpened(LMInBannerVideo var1){

                }

                @Override
                public void onAdClosed(LMInBannerVideo var1){}

                @Override
                public void onAdCompletion(LMInBannerVideo var1) {

                }
            });
            inBannerAdView.loadAd();
        }else{

            adView = new LMBannerView(context,
                    request.publisherId,
                    request.adUnitId,
                    new LMBannerView.LMAdSize(size.width,size.height),
                    request.serverURL);

            adView.setLayoutParams(new LinearLayout.LayoutParams(this.size.width,this.size.height));

            adView.setBannerViewListener(new LMBannerView.BannerViewListener() {
                @Override
                public void onAdReceived() {
                    if (adView != null) {
                        manager.onAdLoaded(adId);
                    }
                }

                @Override
                public void onAdError(Error error) {
                    if (adView != null) {
                        FlutterAdError adErr = new FlutterAdError(1,"LemmaSDK",error.getMessage());
                        manager.onAdFailedToLoad(adId, adErr);
                    }
                }
            });
            adView.loadAd();
        }

    }

    @Nullable
    @Override
    public PlatformView getPlatformView() {
        if (inBannerAdView != null){
            return new FlutterPlatformView(inBannerAdView);
        }
        if (adView != null) {
            return new FlutterPlatformView(adView);
        }
        return null;
    }

    @Override
    void dispose() {
        if (adView != null) {
            adView.destroy();
            adView = null;
        }
        if (inBannerAdView != null) {
            inBannerAdView.destroy();
            inBannerAdView = null;
        }
    }

}
