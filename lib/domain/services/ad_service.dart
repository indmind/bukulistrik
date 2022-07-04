import 'package:bukulistrik/common/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService extends GetxService {
  final _bannerTestId = 'ca-app-pub-3940256099942544/6300978111';
  final _interstitialTestId = 'ca-app-pub-3940256099942544/1033173712';

  final _bannerId = 'ca-app-pub-2149763024462380/4113426593';
  final _interstitialId = 'ca-app-pub-2149763024462380/8231531350';

  @override
  void onInit() {
    super.onInit();

    loadAds();
  }

  String getBannerId(String realId) {
    return kDebugMode ? _bannerTestId : realId;
    // return false ? _bannerTestId : realId;
  }

  String getInterstitialId(String realId) {
    return kDebugMode ? _interstitialTestId : realId;
    // return false ? _interstitialTestId : realId;
  }

  late final RxMap<String, bool> adLoaded = <String, bool>{
    _bannerId: false,
    _interstitialId: false,
  }.obs;

  late final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) {
      adLoaded.update(ad.adUnitId, (value) => true, ifAbsent: () => true);
      Logger.d('AdService.onAdLoaded: ${ad.adUnitId}');
    },
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      adLoaded.update(ad.adUnitId, (value) => false, ifAbsent: () => false);

      Logger.d('AdService.onAdFailedToLoad: ${ad.adUnitId}, $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => Logger.d('AdService.onAdOpened: ${ad.adUnitId}'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => Logger.d('AdService.onAdClosed: ${ad.adUnitId}'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) =>
        Logger.d('AdService.onAdImpression: ${ad.adUnitId}'),
  );

  late final FullScreenContentCallback<InterstitialAd>
      fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
    // Called when the user is about to return to the app after tapping on an ad.
    onAdShowedFullScreenContent: (ad) => Logger.d(
        'AdService.fullScreenCotentCallback: ${ad.adUnitId} onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (ad) {
      Logger.d(
        'AdService.fullScreenCotentCallback: ${ad.adUnitId} onAdDismissedFullScreenContent.',
      );
      ad.dispose();

      // RELOAD ADS
      loadInterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (ad, AdError error) {
      Logger.d(
          'AdService.fullScreenCotentCallback: ${ad.adUnitId} onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
    },
    onAdImpression: (ad) => Logger.d(
        'AdService.fullScreenCotentCallback: ${ad.adUnitId} impression occurred.'),
  );

  late final homeBannerAd = BannerAd(
    size: AdSize.banner,
    adUnitId: getBannerId(_bannerId),
    request: const AdRequest(),
    listener: listener,
  );

  Rx<InterstitialAd?> interstitialAd = Rx<InterstitialAd?>(null);

  Future<void> loadAds() async {
    await homeBannerAd.load();

    await loadInterstitialAd();
  }

  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: getInterstitialId(_interstitialId),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = fullScreenContentCallback;

          interstitialAd.value = ad;

          adLoaded.update(ad.adUnitId, (value) => true, ifAbsent: () => true);

          Logger.d('AdService.ladAds.onAdLoaded: ${ad.adUnitId}');
        },
        onAdFailedToLoad: (LoadAdError error) {
          interstitialAd.value = null;

          Logger.d('AdService.ladAds.onAdFailedToLoad: $error');
        },
      ),
    );
  }
}
