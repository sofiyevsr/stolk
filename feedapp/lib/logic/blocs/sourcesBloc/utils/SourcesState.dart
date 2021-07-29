part of "SourcesBloc.dart";

abstract class SourcesState extends Equatable {
  @override
  get props => [];
}

class SourcesStateInitial extends SourcesState {}

class SourcesStateError extends SourcesState {}

class SourcesStateLoading extends SourcesState {}

class SourcesStateNoData extends SourcesState {}

class SourcesStateSuccess extends SourcesState {
  final SourcesModel data;
  SourcesStateSuccess({
    required this.data,
  });
  @override
  get props => [
        data,
      ];
}
