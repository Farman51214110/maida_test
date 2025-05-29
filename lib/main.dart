// main.dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maida Test',
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  InterstitialAd? _interstitialAd;
  NativeAd? _nativeAd;
  bool _isInterstitialAdReady = false;
  bool _isNativeAdReady = false;
  bool _hasNavigated = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkNetworkAndLoadAds();
    _startSplashTimer();
  }

  void _checkNetworkAndLoadAds() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      _loadInterstitialAd();
      _loadNativeAd();
    } else {
      Future.delayed(const Duration(seconds: 2), _navigateToMain);
    }
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: '<YOUR_INTERSTITIAL_AD_UNIT_ID>',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (_) => _isInterstitialAdReady = false,
      ),
    );
  }

  void _loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: '<YOUR_NATIVE_AD_UNIT_ID>',
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) => setState(() => _isNativeAdReady = true),
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          _isNativeAdReady = false;
        },
      ),
    )..load();
  }

  void _startSplashTimer() {
    Future.delayed(const Duration(seconds: 4), () async {
      if (_isInterstitialAdReady) {
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) => _navigateToMain(),
          onAdFailedToShowFullScreenContent: (ad, error) => _navigateToMain(),
        );
        _interstitialAd!.show();
      } else {
        Future.delayed(const Duration(seconds: 4), _navigateToMain);
      }
    });
  }

  void _navigateToMain() {
    if (!_hasNavigated) {
      _hasNavigated = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainScreen(nativeAd: _isNativeAdReady ? _nativeAd : null),
        ),
      );
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/animations/splash_progress.json',
          width: 200,
          height: 200,
          repeat: false,
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  final NativeAd? nativeAd;

  const MainScreen({Key? key, this.nativeAd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Screen')),
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text('Welcome to Maida Test App'),
            ),
          ),
          if (nativeAd != null)
            Container(
              height: 100,
              child: AdWidget(ad: nativeAd!),
            ),
        ],
      ),
    );
  }
}
