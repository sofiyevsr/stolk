part of "NewsBloc.dart";

class NewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Used for fetching users news history
class FetchHistoryNewsEvent extends NewsEvent {
  final String filterBy;
  FetchHistoryNewsEvent({required this.filterBy});

  List<Object?> get props => [filterBy];
}

class FetchNextHistoryNewsEvent extends NewsEvent {
  final String filterBy;
  final bool? force;
  FetchNextHistoryNewsEvent({required this.filterBy, this.force});

  List<Object?> get props => [filterBy, force];
}

// Only one should be not null maybe assert
class FetchNewsEvent extends NewsEvent {
  final int? category;
  final int? sourceID;
  FetchNewsEvent({required this.category, required this.sourceID});

  List<Object?> get props => [sourceID, category];
}

class RefreshNewsEvent extends NewsEvent {
  final AllNewsResponse data;
  RefreshNewsEvent({required this.data});

  List<Object?> get props => [
        data,
      ];
}

// Only one should be not null maybe assert
class FetchNextNewsEvent extends NewsEvent {
  final int? category;
  final int? sourceID;
  // Force to load next batch even though state is not success
  final bool? force;
  FetchNextNewsEvent({
    required this.category,
    required this.sourceID,
    this.force,
  });

  List<Object?> get props => [category, sourceID, force];
}

class NewsActionEvent extends NewsEvent {
  final int index;
  final NewsActionType type;
  NewsActionEvent({required this.index, required this.type});

  List<Object?> get props => [index, type];
}
