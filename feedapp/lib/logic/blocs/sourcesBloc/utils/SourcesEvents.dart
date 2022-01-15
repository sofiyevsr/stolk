part of "SourcesBloc.dart";

class SourcesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchSourcesEvent extends SourcesEvent {
  FetchSourcesEvent();

  @override
  List<Object?> get props => [];
}

class LoadingSourceAction extends SourcesEvent {
  final int index;
  LoadingSourceAction({required this.index});

  @override
  List<Object?> get props => [index];
}

class ToggleSourceFollow extends SourcesEvent {
  final int id;
  ToggleSourceFollow({required this.id});

  @override
  List<Object?> get props => [id];
}
