class SingleSource {
  final int id;
  final String name;
  final String logoSuffix;
  final int langID;
  final int? followID;
  SingleSource._({
    required this.id,
    required this.logoSuffix,
    required this.langID,
    required this.followID,
    required this.name,
  });
  SingleSource.fromJson(Map<String, dynamic> json)
      : this._(
          langID: json['lang_id'],
          logoSuffix: json['logo_suffix'],
          name: json['name'],
          id: json['id'],
          followID: json['follow_id'],
        );
}

class AllSourcesResponse {
  final List<SingleSource> sources = [];
  AllSourcesResponse.fromJSON(Map<String, dynamic> json) {
    if (json["sources"] != null) {
      for (int i = 0; i < json['sources'].length; i++) {
        sources.add(SingleSource.fromJson(json['sources'][i]));
      }
    }
  }
}
