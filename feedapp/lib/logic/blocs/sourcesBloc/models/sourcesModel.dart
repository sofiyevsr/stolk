import 'package:equatable/equatable.dart';
import 'package:feedapp/utils/@types/response/allSources.dart';

class SourcesModel extends Equatable {
  final List<SingleSource> sources;
  const SourcesModel({
    required this.sources,
  });

  get props => [sources];
}
