package com.example.lemma_sdk;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import lemma.lemmavideosdk.interstitial.LMInterstitial;
import lemma.lemmavideosdk.videointerstitial.LMVideoInterstitial;

class FlutterInterstitialAd extends FlutterAd.FlutterOverlayAd implements LMInterstitial.LMInterstitialListener {
    private static final String TAG = "FlutterInterstitialAd";

    @NonNull
    private final AdInstanceManager manager;
    @NonNull private final FlutterAdRequest request;
    @Nullable
    private LMInterstitial interstitial;

    @Nullable
    private LMVideoInterstitial videoInterstitial;

    public void setContext(Context context) {
        this.context = context;
    }

    private Context context;

    public FlutterInterstitialAd(
            int adId,
            @NonNull AdInstanceManager manager,
            @NonNull FlutterAdRequest request) {
        super(adId);
        this.manager = manager;
        this.request = request;
    }

    void  setupVideoInst() {

        if (null != videoInterstitial) {
            videoInterstitial.destroy();
            videoInterstitial = null;
        }

        videoInterstitial = new LMVideoInterstitial(context,
                request.publisherId,
                request.adUnitId,
                request.serverURL);

        videoInterstitial.setListener(new LMVideoInterstitial.LMVideoInterstitialListener() {
            @Override
            public void onAdReceived(LMVideoInterstitial lmVideoInterstitial) {
                manager.onAdLoaded(adId);
            }

            @Override
            public void onAdFailed(LMVideoInterstitial lmVideoInterstitial, Error error) {
                FlutterAdError adErr = new FlutterAdError(1,"LemmaSDK",error.getMessage());
                manager.onAdFailedToLoad(adId, adErr);
            }

            @Override
            public void onAdOpened(LMVideoInterstitial lmVideoInterstitial) {
                manager.onAdWillPresent(adId);
            }

            @Override
            public void onAdClosed(LMVideoInterstitial lmVideoInterstitial) {
                videoInterstitial = null;
                manager.onAdDissmissed(adId);
            }

            @Override
            public void onAdCompletion(LMVideoInterstitial lmVideoInterstitial) {

            }
        });
        videoInterstitial.loadAd();
    }

    @Override
    void load() {
        if (manager != null && request != null) {

            if(request.switchToVideo) {
                setupVideoInst();
            }else{
                if (null != interstitial) {
                    interstitial.destroy();
                    interstitial = null;
                }

                interstitial = new LMInterstitial(context,
                        request.publisherId,
                        request.adUnitId,
                        request.serverURL);

                interstitial.setListener(this);
                interstitial.loadAd();
            }
        }
    }

    @Override
    public void onAdReceived(LMInterstitial ad) {
        manager.onAdLoaded(adId);
    }

    @Override
    public void onAdFailed(LMInterstitial ad, Error error) {
        FlutterAdError adErr = new FlutterAdError(1,"LemmaSDK",error.getMessage());
        manager.onAdFailedToLoad(adId, adErr);
    }

    @Override
    public void onAdOpened(LMInterstitial ad) {
        manager.onAdWillPresent(adId);
    }

    @Override
    public void onAdClosed(LMInterstitial ad) {
        interstitial = null;
        manager.onAdDissmissed(adId);
    }

    @Override
    void dispose() {
        interstitial = null;
        videoInterstitial = null;
    }

    @Override
    public void show() {
        if (interstitial == null && videoInterstitial == null) {
            Log.e(TAG, "Error showing interstitial - the interstitial ad wasn't loaded yet.");
            return;
        }
        if (manager.getActivity() == null) {
            Log.e(TAG, "Tried to show interstitial before activity was bound to the plugin.");
            return;
        }

        if (interstitial != null){
            interstitial.show();
        }else if (videoInterstitial != null) {
            videoInterstitial.show();
        }
    }
}

