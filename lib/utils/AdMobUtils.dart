import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

import 'package:protein_tracker/apikeys.dart';

class AdMobUtils {
  static String getAppId() {
    return apikeys["appId"];
  }

  static String getBannerAdUnitId() {
    return apikeys["adMobBanner"];
  }

  static Widget admobBanner() {
    return AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: AdmobBannerSize.BANNER,
    );
  }
}
