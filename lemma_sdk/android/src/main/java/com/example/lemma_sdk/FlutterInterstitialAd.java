package com.example.lemma_sdk;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import lemma.lemmavideosdk.interstitial.LMInterstitial;

class FlutterInterstitialAd extends FlutterAd.FlutterOverlayAd implements LMInterstitial.LMInterstitialListener {
    private static final String TAG = "FlutterInterstitialAd";

    @NonNull
    private final AdInstanceManager manager;
    @NonNull private final FlutterAdRequest request;
    @Nullable
    private LMInterstitial interstitial;

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

    @Override
    void load() {
        if (manager != null && request != null) {

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
        Log.d(TAG, "Ad Closed");
        interstitial = null;
        manager.onAdDissmissed(adId);
    }

    @Override
    void dispose() {
        interstitial = null;
    }

    @Override
    public void show() {
        if (interstitial == null) {
            Log.e(TAG, "Error showing interstitial - the interstitial ad wasn't loaded yet.");
            return;
        }
        if (manager.getActivity() == null) {
            Log.e(TAG, "Tried to show interstitial before activity was bound to the plugin.");
            return;
        }
        interstitial.show();
    }
}

