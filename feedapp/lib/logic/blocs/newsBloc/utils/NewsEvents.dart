part of "NewsBloc.dart";

class NewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Only one should be not null maybe assert
class FetchNewsEvent extends NewsEvent {
  final int? category;
  final int? sourceID;
  final int? sortBy;
  final int? period;
  FetchNewsEvent({
    required this.category,
    required this.sourceID,
    required this.sortBy,
    required this.period,
  });

  List<Object?> get props => [
        sourceID,
        category,
        sortBy,
        period,
      ];
}

class RefreshNewsEvent extends NewsEvent {
  final AllNewsResponse data;
  final int? sortBy;
  final int? period;
  final int? category;
  RefreshNewsEvent({
    required this.data,
    required this.sortBy,
    required this.period,
    required this.category,
  });

  List<Object?> get props => [
        data,
        sortBy,
        category,
        period,
      ];
}

// Only one should be not null maybe assert
class FetchNextNewsEvent extends NewsEvent {
  final int? sourceID;
  // Force to load next batch even though state is not success
  final bool? force;
  FetchNextNewsEvent({
    required this.sourceID,
    this.force,
  });

  List<Object?> get props => [sourceID, force];
}

class NewsActionEvent extends NewsEvent {
  final int index;
  final NewsActionType type;
  NewsActionEvent({required this.index, required this.type});

  List<Object?> get props => [index, type];
}

class FetchBookmarks extends NewsEvent {
  FetchBookmarks();

  List<Object?> get props => [];
}

class FetchNextBookmarks extends NewsEvent {
  final bool? force;
  FetchNextBookmarks({this.force});

  List<Object?> get props => [force];
}
