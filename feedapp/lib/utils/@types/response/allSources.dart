import '../../common.dart';

class SingleSource {
  final int id;
  final String name;
  final String logoSuffix;
  final int langID;
  final int? followID;
  final bool isRequestOn;
  SingleSource._({
    required this.id,
    required this.logoSuffix,
    required this.langID,
    required this.followID,
    required this.name,
    this.isRequestOn = false,
  });
  SingleSource.fromJson(Map<String, dynamic> json)
      : this._(
          langID: json['lang_id'],
          logoSuffix: json['logo_suffix'],
          name: json['name'],
          id: json['id'],
          followID: json['follow_id'],
        );

  SingleSource copyWith({
    int? id,
    String? logoSuffix,
    int? langID,
    Nullable<int>? followID,
    String? name,
    bool? isRequestOn,
  }) =>
      SingleSource._(
        id: id ?? this.id,
        logoSuffix: logoSuffix ?? this.logoSuffix,
        langID: langID ?? this.langID,
        followID: followID == null ? this.followID : followID.value,
        name: name ?? this.name,
        isRequestOn: isRequestOn ?? this.isRequestOn,
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
