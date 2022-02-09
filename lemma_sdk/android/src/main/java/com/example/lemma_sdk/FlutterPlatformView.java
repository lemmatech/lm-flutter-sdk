package com.example.lemma_sdk;


import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.platform.PlatformView;

class FlutterPlatformView implements PlatformView {

    @Nullable
    private View view;

    FlutterPlatformView(@NonNull View view) {
        this.view = view;
    }

    @Override
    public View getView() {
        return view;
    }

    @Override
    public void dispose() {
        this.view = null;
    }
}

