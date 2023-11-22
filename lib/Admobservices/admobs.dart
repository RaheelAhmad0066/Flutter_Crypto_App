import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Admobservice {
  static String? get banneradunit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    return null;
  }

  static String? get interestitialAndroid {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    return null;
  }

  static String? get rewardedadd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    }
    return null;
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: ((ad) => debugPrint('AD loaded.')),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('ad failed: $error');
    },
    onAdOpened: (ad) => debugPrint('ad open'),
    onAdClosed: (ad) => debugPrint('ad close'),
  );
}
