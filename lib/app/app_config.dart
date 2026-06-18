class AppConfig {
  const AppConfig._();

  static const adsEnabled = true;
  static const interstitialAdsEnabled = false;
  static const premiumEnabled = false;
  static const isPremiumUser = false;

  static const androidAdMobAppId = 'ca-app-pub-4665787383933447~6151719227';
  static const bannerHomeAdUnitId = 'ca-app-pub-4665787383933447/1810088880';
  static const bannerHistoryAdUnitId = 'ca-app-pub-4665787383933447/8183925542';
  static const bannerGuideAdUnitId = 'ca-app-pub-4665787383933447/3715227766';
  static const resultInterstitialAdUnitId =
      'ca-app-pub-4665787383933447/9678140505';

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
