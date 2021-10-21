part of "NewsHistoryBloc.dart";

class NewsHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Used for fetching users news history
class FetchHistoryNewsEvent extends NewsHistoryEvent {
  final String filterBy;
  FetchHistoryNewsEvent({required this.filterBy});

  List<Object?> get props => [filterBy];
}

class FetchNextHistoryNewsEvent extends NewsHistoryEvent {
  final String filterBy;
  final bool? force;
  FetchNextHistoryNewsEvent({required this.filterBy, this.force});

  List<Object?> get props => [filterBy, force];
}
