import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/task_data.dart';

class AdMobService {
  //TODO Go to admob, add ad units, then paste them here
  static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-8367396786813647/1578705787'
      : 'ca-app-pub-8367396786813647/1578705787';

  static String get iOsInterstitialAdUnitID => Platform.isAndroid
      ? 'ca-app-pub-8367396786813647/4150040568'
      : 'ca-app-pub-8367396786813647/4150040568';
  static InterstitialAd _interstitialAd;
  static initialize() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  static BannerAd createBannerAd() {
    BannerAd ad = new BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      listener: AdListener(
        onAdLoaded: (Ad ad) => print('Ad loaded'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('Ad opened'),
        onAdClosed: (Ad ad) => print('On Ad Closed'),
      ),
      request: AdRequest(),
    );
    return ad;
  }

  static BannerAd taskCreateBannerAd() {
    BannerAd ad = new BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      listener: AdListener(
        onAdLoaded: (Ad ad) => print('Ad loaded'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('Ad opened'),
        onAdClosed: (Ad ad) => print('On Ad Closed'),
      ),
      request: AdRequest(),
    );
    return ad;
  }

  static InterstitialAd _createInterstitialAd() {
    return InterstitialAd(
        adUnitId: iOsInterstitialAdUnitID,
        listener: AdListener(
            onAdLoaded: (Ad ad) => {_interstitialAd.show()},
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) => print('Ad opened'),
            onAdClosed: (Ad ad) => {_interstitialAd.dispose()},
            onApplicationExit: (Ad ad) => {_interstitialAd.dispose()}),
        request: AdRequest());
  }

  static void showInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    if (_interstitialAd == null) _interstitialAd = _createInterstitialAd();
    _interstitialAd.load();
  }
}
