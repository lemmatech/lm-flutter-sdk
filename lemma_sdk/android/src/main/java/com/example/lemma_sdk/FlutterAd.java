package com.example.lemma_sdk;

import androidx.annotation.Nullable;

import io.flutter.plugin.platform.PlatformView;

abstract class FlutterAd {

    public abstract static class FlutterOverlayAd extends FlutterAd {
        abstract void show();

        FlutterOverlayAd(int adId) {
            super(adId);
        }
    }

    protected final int adId;

    FlutterAd(int adId) {
        this.adId = adId;
    }

    /**
     * Invoked when dispose() is called on the corresponding Flutter ad object. This perform any
     * necessary cleanup.
     */
    abstract void dispose();

    abstract void load();

    /**
     * Gets the PlatformView for the ad. Default behavior is to return null. Should be overridden by
     * ads with platform views, such as banner and native ads.
     */
    @Nullable
    PlatformView getPlatformView() {
        return null;
    }

}
