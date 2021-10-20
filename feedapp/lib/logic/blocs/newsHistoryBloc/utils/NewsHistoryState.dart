part of "NewsHistoryBloc.dart";

abstract class NewsHistoryState extends Equatable {
  @override
  get props => [];
}

abstract class NewsHistoryStateWithData extends NewsHistoryState {
  final NewsHistoryModel data;
  NewsHistoryStateWithData({required this.data});
  @override
  get props => [data];
}

class NewsHistoryStateInitial extends NewsHistoryState {}

class NewsHistoryStateError extends NewsHistoryState {}

class NewsHistoryNextFetchError extends NewsHistoryStateWithData {
  NewsHistoryNextFetchError({
    required NewsHistoryModel data,
  }) : super(data: data);
}

class NewsHistoryNextFetchLoading extends NewsHistoryStateWithData {
  NewsHistoryNextFetchLoading({
    required NewsHistoryModel data,
  }) : super(data: data);
}

class NewsHistoryStateLoading extends NewsHistoryState {}

class NewsHistoryStateNoData extends NewsHistoryState {}

class NewsHistoryStateSuccess extends NewsHistoryStateWithData {
  NewsHistoryStateSuccess({
    required NewsHistoryModel data,
  }) : super(data: data);
}
