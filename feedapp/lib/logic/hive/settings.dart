import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 0)
class Settings {
  @HiveField(0)
  bool skipIntro;
  @HiveField(0)
  String theme;

  Settings({this.skipIntro = false, this.theme = "system"});
}
