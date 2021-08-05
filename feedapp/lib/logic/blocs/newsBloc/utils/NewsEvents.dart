part of "NewsBloc.dart";

class NewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Only one should be not null maybe assert
class FetchNewsEvent extends NewsEvent {
  final int? category;
  final String? filterBy;
  final int? sourceID;
  FetchNewsEvent(
      {required this.category, required this.filterBy, required this.sourceID});

  List<Object?> get props => [filterBy, category];
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
  final String? filterBy;
  final int? sourceID;
  final bool? force;
  FetchNextNewsEvent({
    required this.category,
    required this.filterBy,
    required this.sourceID,
    this.force,
  });

  List<Object?> get props => [filterBy, category, sourceID, force];
}

class NewsActionEvent extends NewsEvent {
  final int index;
  final NewsActionType type;
  NewsActionEvent({required this.index, required this.type});

  List<Object?> get props => [index, type];
}
