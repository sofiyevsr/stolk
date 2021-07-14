part of "NewsBloc.dart";

class NewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNewsEvent extends NewsEvent {}

class RefreshNewsEvent extends NewsEvent {
  final AllNewsResponse data;
  RefreshNewsEvent({required this.data});
}

class FetchNextNewsEvent extends NewsEvent {}
