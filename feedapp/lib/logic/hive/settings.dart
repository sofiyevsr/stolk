import 'package:hive/hive.dart';
import 'package:feedapp/utils/constants.dart';

part 'settings.g.dart';

@HiveType(typeId: 0)
class Settings {
  @HiveField(0)
  List<int> cats;

  @HiveField(1)
  int radius;

  @HiveField(2)
  List<int> banners;

  @HiveField(3)
  bool skipIntro;

  Settings({
    this.cats = DEFAULT_CATS,
    this.radius = DEFAULT_RADIUS,
    this.banners = DEFAULT_BANNERS,
    this.skipIntro = false,
  });
}
