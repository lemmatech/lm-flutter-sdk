import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:lemma_sdk/lemma_sdk.dart';

class InterstitialExample extends StatefulWidget {
  const InterstitialExample({Key? key}) : super(key: key);

  @override
  State<InterstitialExample> createState() => _InterstitialExampleState();
}

class _InterstitialExampleState extends State<InterstitialExample> {
  String _platformVersion = 'Unknown';
  InterstitialAd? _interstitialAd;

  void _createInterstitialAd() {
    InterstitialAd.load(
        request: AdRequest(
            publisherId: "<PUB_ID>",
            adunitId: "<AD_UNIT_ID>"),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _interstitialAd?.fullScreenContentCallback =
                FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
              print('$ad onAdDismissedFullScreenContent');
            }, onAdShowingFullScreenContent: (ad) {
              print('$ad onAdShowingFullScreenContent');
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _interstitialAd = null;
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // LemmaSDK.enableLogs(true);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await LemmaSDK.version();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sample app'),
        ),
        body: Container(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text('SDK version: $_platformVersion\n'),
              ),
              TextButton(
                child: Text('Load Ad'),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  _createInterstitialAd();
                },
              ),
              TextButton(
                child: Text('Show Ad'),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  if (_interstitialAd != null) {
                    _interstitialAd?.show();
                  }
                },
              )
            ],
          ),
        )));
  }
}
