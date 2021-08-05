part of "NewsBloc.dart";

abstract class NewsState extends Equatable {
  @override
  get props => [];
}

abstract class NewsStateWithData extends NewsState {
  final NewsModel data;
  NewsStateWithData({required this.data});
  @override
  get props => [data];
}

class NewsStateInitial extends NewsState {}

class NewsStateError extends NewsState {}

class NewsNextFetchError extends NewsStateWithData {
  NewsNextFetchError({
    required NewsModel data,
  }) : super(data: data);
}

class NewsNextFetchLoading extends NewsStateWithData {
  NewsNextFetchLoading({
    required NewsModel data,
  }) : super(data: data);
}

class NewsStateLoading extends NewsState {}

class NewsStateNoData extends NewsState {}

class NewsStateSuccess extends NewsStateWithData {
  NewsStateSuccess({
    required NewsModel data,
  }) : super(data: data);
}
