import 'dart:io';

import 'package:calculadora_laboral_mx/app/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

bool get _supportsMobileAds =>
    !kIsWeb && (Platform.isAndroid || Platform.isIOS);

class AppAdBanner extends StatefulWidget {
  const AppAdBanner({required this.adUnitId, super.key});

  final String adUnitId;

  @override
  State<AppAdBanner> createState() => _AppAdBannerState();
}

class _AppAdBannerState extends State<AppAdBanner> {
  BannerAd? _ad;
  bool _isLoaded = false;
  bool _hasFailed = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (!AppConfig.showAds || !_supportsMobileAds) return;

    final ad = BannerAd(
      adUnitId: widget.adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (loadedAd) {
          if (!mounted) {
            loadedAd.dispose();
            return;
          }
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (failedAd, error) {
          failedAd.dispose();
          if (!mounted) return;
          setState(() => _hasFailed = true);
        },
      ),
    );

    _ad = ad;
    ad.load();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!AppConfig.showAds || !_supportsMobileAds || _hasFailed || ad == null) {
      return const SizedBox.shrink();
    }

    if (!_isLoaded) {
      return SizedBox(height: AdSize.banner.height.toDouble());
    }

    return Center(
      child: SizedBox(
        width: ad.size.width.toDouble(),
        height: ad.size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }
}

class AppInterstitialAds {
  const AppInterstitialAds._();

  static InterstitialAd? _ad;
  static bool _isLoading = false;

  static void preload() {
    if (!AppConfig.showInterstitial || !_supportsMobileAds) return;
    if (_ad != null || _isLoading) return;

    _isLoading = true;
    InterstitialAd.load(
      adUnitId: AppConfig.resultInterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          _ad = ad;
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          _ad = null;
        },
      ),
    );
  }

  static void maybeShowAfterResult(BuildContext context) {
    if (!AppConfig.showInterstitial || !_supportsMobileAds) return;

    final readyAd = _ad;
    if (readyAd != null) {
      _show(readyAd);
      return;
    }

    if (_isLoading) return;
    _isLoading = true;
    InterstitialAd.load(
      adUnitId: AppConfig.resultInterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          _show(ad);
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          _ad = null;
        },
      ),
    );
  }

  static void _show(InterstitialAd ad) {
    _ad = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (dismissedAd) {
        dismissedAd.dispose();
        preload();
      },
      onAdFailedToShowFullScreenContent: (failedAd, error) {
        failedAd.dispose();
        preload();
      },
      onAdShowedFullScreenContent: (shownAd) {
        _ad = null;
      },
    );
    ad.show();
  }
}
