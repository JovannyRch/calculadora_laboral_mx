class AppConfig {
  const AppConfig._();

  static const adsEnabled = true;
  static const interstitialAdsEnabled = false;
  static const premiumEnabled = false;
  static const isPremiumUser = false;

  static const bannerHomeAdUnitId = 'ca-app-pub-0000000000000000/home-banner';
  static const bannerHistoryAdUnitId =
      'ca-app-pub-0000000000000000/history-banner';
  static const bannerGuideAdUnitId = 'ca-app-pub-0000000000000000/guide-banner';
  static const resultInterstitialAdUnitId =
      'ca-app-pub-0000000000000000/result-interstitial';

  static bool get showAds => adsEnabled && !isPremiumUser;
  static bool get showInterstitial => interstitialAdsEnabled && !isPremiumUser;
}

class PremiumFeatures {
  const PremiumFeatures._();

  static const noAds = true;
  static const unlimitedPdf = true;
  static const unlimitedHistory = true;
  static const advancedComparator = true;
  static const exportAndShare = true;
}
