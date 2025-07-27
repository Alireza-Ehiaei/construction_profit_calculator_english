import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';


/*class MyBannerAdWidget extends StatefulWidget {
  const MyBannerAdWidget({super.key});

  @override
  MyBannerAdWidgetState createState() => MyBannerAdWidgetState();
}

class MyBannerAdWidgetState extends State<MyBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7178751328162697/7429674784', // Your Android ad unit ID
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
       //   print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SizedBox(
          width: _bannerAd?.size.width.toDouble() ?? 0,
          height: _bannerAd?.size.height.toDouble() ?? 0,
          child: _isAdLoaded ? AdWidget(ad: _bannerAd!) : const SizedBox(),
        ),
      ),
    );
  }
}



class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  int _loadAttempts = 0;
  static const int maxLoadAttempts = 3;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-7178751328162697/3888048856',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _loadAttempts = 0; // Reset attempts on success

        },
        onAdFailedToLoad: (LoadAdError error) {
          _loadAttempts += 1;
      //    print('Failed to load interstitial ad: $error');
          if (_loadAttempts < maxLoadAttempts) {
            loadInterstitialAd(); // Retry loading the ad
          }
        },
      ),
    );
  }

  Future<void> showInterstitialAd(BuildContext context) async {
    if (_interstitialAd != null) {
      final completer = Completer<void>();

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          loadInterstitialAd(); // Load a new ad for next time
          completer.complete(); // Complete the Future when dismissed
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
        //  print('Failed to show interstitial ad: $error');
          completer.complete(); // Complete even if it fails to show
        },
      );

      _interstitialAd!.show();
      return completer.future; // Wait for completion
    } else {

      return Future.value(); // Return an empty Future if not ready
    }
  }

  void dispose() {
    _interstitialAd?.dispose(); // Dispose of the current ad if it exists
  }
}*/



// ################## ################## ################## ##################



// admanager Is useful when you want to call it in  initstate of
// the page you want to show an ad by:   AdManager().loadInterstitialAd();
/*
class AdManager {
  static final AdManager _instance = AdManager._internal();

  // Banner Ad
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  // Interstitial Ad
  InterstitialAd? _interstitialAd;

  factory AdManager() {
    return _instance;
  }

  AdManager._internal();

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Replace with your ad unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Interstitial Ad failed to load: $error');
        },
      ),
    );
  }

  void showInterstitialAd(Function onComplete) {
    if (_interstitialAd != null) {
      _interstitialAd!.show().then((_) {
        onComplete();
        loadInterstitialAd(); // Load another ad for next time
      });
    } else {
      debugPrint('Interstitial Ad is not ready yet.');
      onComplete(); // Proceed without showing if not ready
    }
  }

  Widget getBannerWidget() {
    return SafeArea(
      child: SizedBox(
        width: _bannerAd?.size.width.toDouble() ?? 0,
        height: _bannerAd?.size.height.toDouble() ?? 0,
        child: _isBannerAdLoaded ? AdWidget(ad: _bannerAd!) : const SizedBox(),
      ),
    );
  }

  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }
}*/
