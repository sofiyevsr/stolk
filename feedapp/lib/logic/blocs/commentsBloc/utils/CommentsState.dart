part of "CommentsBloc.dart";

abstract class CommentsState extends Equatable {
  @override
  get props => [];
}

class CommentsStateInitial extends CommentsState {}

class CommentsStateError extends CommentsState {}

class CommentsStateLoading extends CommentsState {}

class CommentsStateNoData extends CommentsState {}

class CommentsStateSuccess extends CommentsState {
  final CommentsModel data;
  final bool isLoadingNext;
  CommentsStateSuccess({
    required this.data,
    required this.isLoadingNext,
  });
  CommentsStateSuccess setLoading() => CommentsStateSuccess(
        isLoadingNext: true,
        data: this.data,
      );
  CommentsStateSuccess disableLoading() => CommentsStateSuccess(
        isLoadingNext: false,
        data: this.data,
      );
  @override
  get props => [
        data,
        isLoadingNext,
      ];
}
