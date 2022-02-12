package com.example.lemma_sdk;

class FlutterAdError {

    public Integer code;

    public FlutterAdError(Integer code, String domain, String message) {
        this.code = code;
        this.domain = domain;
        this.message = message;
    }

    public String domain, message;
}
