package com.example.lemma_sdk;

import android.content.Context;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.platform.PlatformView;
import lemma.lemmavideosdk.banner.LMBannerView;

class FlutterBannerAd extends FlutterAd  {

    @NonNull private final AdInstanceManager manager;
    @NonNull private final FlutterAdSize size;
    @NonNull private final FlutterAdRequest request;
    @Nullable
    private LMBannerView adView;

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
                    FlutterAdError err = new FlutterAdError();
                    manager.onAdFailedToLoad(adId, err);
                }
            }
        });
        adView.loadAd();
    }

    @Nullable
    @Override
    public PlatformView getPlatformView() {
        if (adView == null) {
            return null;
        }
        return new FlutterPlatformView(adView);
    }

    @Override
    void dispose() {
        if (adView != null) {
            adView.destroy();
            adView = null;
        }
    }

}
