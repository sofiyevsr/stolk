import 'package:stolk/utils/@types/response/allSources.dart';

class SourcesModel {
  final List<SingleSource> sources;
  const SourcesModel({
    required this.sources,
  });
  SourcesModel modifySingle({
    required SingleSource item,
    required int id,
  }) {
    final clonedItems = sources.map((e) {
      if (e.id == id) return item;
      return e;
    }).toList();
    return SourcesModel(
      sources: clonedItems,
    );
  }
}
