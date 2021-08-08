part of "CommentsBloc.dart";

abstract class CommentsState extends Equatable {
  @override
  get props => [];
}

abstract class CommentsStateWithData extends CommentsState {
  final CommentsModel data;
  CommentsStateWithData({required this.data});
  @override
  get props => [data];
}

class CommentsStateInitial extends CommentsState {}

class CommentsStateError extends CommentsState {}

class CommentsStateLoading extends CommentsState {}

class CommentsStateNoData extends CommentsState {}

class CommentsStateSuccess extends CommentsStateWithData {
  CommentsStateSuccess({
    required CommentsModel data,
  }) : super(data: data);
}

class CommentsNextFetchError extends CommentsStateWithData {
  CommentsNextFetchError({
    required CommentsModel data,
  }) : super(data: data);
}

class CommentsNextFetchLoading extends CommentsStateWithData {
  CommentsNextFetchLoading({
    required CommentsModel data,
  }) : super(data: data);
}
