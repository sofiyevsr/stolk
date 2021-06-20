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
  NewsStateSuccess({required this.data});
  @override
  get props => [data];
}
