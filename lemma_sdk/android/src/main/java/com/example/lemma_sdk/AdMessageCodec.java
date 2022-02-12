package com.example.lemma_sdk;

import android.content.Context;
import android.location.Location;

import androidx.annotation.NonNull;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;

import io.flutter.plugin.common.StandardMessageCodec;

class AdMessageCodec extends StandardMessageCodec {

    @NonNull
    Context context;

    private static final byte VALUE_AD_SIZE = (byte) 128;
    private static final byte VALUE_AD_REQUEST = (byte) 129;
    private static final byte VALUE_LOAD_AD_ERROR = (byte) 133;
    private static final byte VALUE_LOCATION_PARAMS = (byte) 147;

    void setContext(@NonNull Context context) {
        this.context = context;
    }

    AdMessageCodec(@NonNull Context context) {
        this.context = context;
    }

    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value) {
        if (value instanceof FlutterAdSize) {
            stream.write(VALUE_AD_SIZE);
            writeValue(stream, ((FlutterAdSize) value).width);
            writeValue(stream, ((FlutterAdSize) value).height);
        } else if (value instanceof FlutterAdRequest) {
            stream.write(VALUE_AD_REQUEST);
            final FlutterAdRequest request = (FlutterAdRequest) value;
            writeValue(stream, ((FlutterAdRequest) value).publisherId);
            writeValue(stream, ((FlutterAdRequest) value).adUnitId);
            writeValue(stream, ((FlutterAdRequest) value).serverURL);
            writeValue(stream, ((FlutterAdRequest) value).networkTimeout);
            writeValue(stream, ((FlutterAdRequest) value).switchToVideo);
        } else if (value instanceof FlutterAdError) {
            stream.write(VALUE_LOAD_AD_ERROR);
            writeValue(stream, ((FlutterAdError) value).code);
            writeValue(stream, ((FlutterAdError) value).domain);
            writeValue(stream, ((FlutterAdError) value).message);
        } else if (value instanceof Location) {
            stream.write(VALUE_LOCATION_PARAMS);
            writeValue(stream, ((Location) value).getLatitude());
            writeValue(stream, ((Location) value).getLongitude());
        } else {
            super.writeValue(stream, value);
        }
    }

    @SuppressWarnings("unchecked")
    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
        switch (type) {
            case VALUE_AD_SIZE: {
                final Integer width = (Integer) readValueOfType(buffer.get(), buffer);
                final Integer height = (Integer) readValueOfType(buffer.get(), buffer);
                return new FlutterAdSize(context, width, height);
            }
            case VALUE_AD_REQUEST:
                FlutterAdRequest request = new FlutterAdRequest();
                final String pubId = (String) readValueOfType(buffer.get(), buffer);
                final String adunit = (String) readValueOfType(buffer.get(), buffer);
                final String serverURL = (String) readValueOfType(buffer.get(), buffer);
                final Integer networkTimeout = (Integer) readValueOfType(buffer.get(), buffer);
                final Boolean switchToVideo = (Boolean) readValueOfType(buffer.get(), buffer);
                request.publisherId = pubId;
                request.adUnitId = adunit;
                request.serverURL = serverURL;
                request.networkTimeout = networkTimeout;
                request.switchToVideo = switchToVideo;
                return request;
            case VALUE_LOAD_AD_ERROR:
                final Integer code = (Integer) readValueOfType(buffer.get(), buffer);
                final String domain = (String) readValueOfType(buffer.get(), buffer);
                final String msg = (String) readValueOfType(buffer.get(), buffer);
                return new FlutterAdError(code, domain, msg);
            case VALUE_LOCATION_PARAMS:
                Location location = new Location("");
                return location;
            default:
                return super.readValueOfType(type, buffer);
        }
    }
}
