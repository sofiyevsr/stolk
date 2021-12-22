import 'package:flutter/foundation.dart';

const _testUnitId = 'ca-app-pub-3940256099942544/6300978111';
enum AdPlacements {
  home,
  newsView,
}

Map<AdPlacements, String> unitIDs = {
  AdPlacements.home: "ca-app-pub-3258697841522212/3612296621",
  AdPlacements.newsView: "ca-app-pub-3258697841522212/6976185930",
};

String getUnitID(AdPlacements ad) {
  if (kReleaseMode == true && unitIDs.containsKey(ad)) {
    return unitIDs[ad]!;
  } else {
    return _testUnitId;
  }
}
