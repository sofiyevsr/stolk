part of "SourcesBloc.dart";

class SourcesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchSourcesEvent extends SourcesEvent {
  FetchSourcesEvent();

  List<Object?> get props => [];
}

class LoadingSourceAction extends SourcesEvent {
  final int index;
  LoadingSourceAction({required this.index});

  List<Object?> get props => [index];
}

class ToggleSourceFollow extends SourcesEvent {
  final int id;
  ToggleSourceFollow({required this.id});

  List<Object?> get props => [id];
}
