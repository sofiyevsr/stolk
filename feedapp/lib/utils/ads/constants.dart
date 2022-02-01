import 'dart:io';

import 'package:flutter/foundation.dart';

const _testUnitId = 'ca-app-pub-3940256099942544/6300978111';
enum AdPlacements {
  home,
  newsGrid,
}

Map<AdPlacements, String> unitIDs = {
  AdPlacements.home: "ca-app-pub-3258697841522212/3612296621",
  AdPlacements.newsGrid: "ca-app-pub-3258697841522212/6976185930",
};

Map<AdPlacements, String> iosUnitIDs = {
  AdPlacements.home: "ca-app-pub-3258697841522212/9485014334",
  AdPlacements.newsGrid: "ca-app-pub-3258697841522212/8732343470",
};

String getUnitID(AdPlacements ad) {
  if (kReleaseMode == false) {
    return _testUnitId;
  }
  if (Platform.isIOS == true) {
    return iosUnitIDs[ad]!;
  }
  return unitIDs[ad]!;
}
