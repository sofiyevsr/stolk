part of "NewsBloc.dart";

abstract class NewsState extends Equatable {
  @override
  get props => [];
}

class NewsStateInitial extends NewsState {}

class NewsStateError extends NewsState {}

class NewsStateLoading extends NewsState {}

class NewsStateNoData extends NewsState {}

class NewsStateSuccess extends NewsState {
  final News data;
  final bool isLoadingNext;
  NewsStateSuccess({required this.data, required this.isLoadingNext});
  NewsStateSuccess copyWith(bool isLoading) =>
      NewsStateSuccess(data: this.data, isLoadingNext: isLoading);
  @override
  get props => [data];
}
