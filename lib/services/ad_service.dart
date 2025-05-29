import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Singleton service to load and manage AdMob Interstitial and Native ads.
class AdService {
  AdService._internal();
  static final AdService instance = AdService._internal();

  InterstitialAd? _interstitialAd;
  NativeAd? _nativeAd;
  bool _isInterstitialReady = false;
  bool _isNativeReady = false;

  /// Whether the interstitial ad is loaded and ready to show.
  bool get isInterstitialReady => _isInterstitialReady;

  /// Whether the native ad is loaded and ready to embed.
  bool get isNativeReady => _isNativeReady;

  /// The loaded native ad (null if not ready).
  NativeAd? get nativeAd => _isNativeReady ? _nativeAd : null;

  /// Initialize loading of both ads, if network is available.
  Future<void> loadAds() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return;
    _loadInterstitial();
    _loadNative();
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: '<YOUR_INTERSTITIAL_AD_UNIT_ID>',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
        },
        onAdFailedToLoad: (error) {
          _isInterstitialReady = false;
        },
      ),
    );
  }

  void _loadNative() {
    _nativeAd = NativeAd(
      adUnitId: '<YOUR_NATIVE_AD_UNIT_ID>',
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _isNativeReady = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _isNativeReady = false;
        },
      ),
    )..load();
  }

  /// Shows the interstitial ad if ready; otherwise immediately calls [onDismiss].
  void showInterstitial({required VoidCallback onDismiss}) {
    if (!_isInterstitialReady || _interstitialAd == null) {
      onDismiss();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) => onDismiss(),
      onAdFailedToShowFullScreenContent: (ad, error) => onDismiss(),
    );
    _interstitialAd!.show();
  }

  /// Dispose loaded ads when no longer needed.
  void dispose() {
    _interstitialAd?.dispose();
    _nativeAd?.dispose();
  }
}
