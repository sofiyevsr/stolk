import 'package:hive/hive.dart';

part 'sources.g.dart';

@HiveType(typeId: 1)
class Sources {
  @HiveField(0)
  List<int> sources;

  Sources({
    this.sources = const [],
  });
}
