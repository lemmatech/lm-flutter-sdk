import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:lemma_sdk/lemma_sdk.dart';

class BannerExample extends StatefulWidget {
  const BannerExample({Key? key}) : super(key: key);

  @override
  State<BannerExample> createState() => _BannerExampleState();
}

class _BannerExampleState extends State<BannerExample> {
  String _platformVersion = 'Unknown';
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    // LemmaSDK.enableLogs(true)
  }

  void _loadAd() {
    AdRequest request = AdRequest(
        publisherId: "<PUB_ID>",
        adunitId: "<AD_UNIT_ID>");
    // request.switchToVideo = true;
    _bannerAd = BannerAd(
        size: AdSize(width: 320, height: 50),
        request: request,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            print('$BannerAd loaded.');
            setState(() {
              _isLoaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('$BannerAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        ))
      ..load();
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

  Widget _getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_bannerAd != null && _isLoaded) {
          return Container(
            width: 320,
            height: 50,
            child: AdWidget(ad: _bannerAd!),
          );
        }
        return Container(
          width: 320,
          height: 50,
          color: Colors.grey,
        );
      },
    );
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
                  _loadAd();
                },
              ),
              _getAdWidget()
            ],
          ),
        )));
  }
}
