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
  FetchNewsEvent({
    required this.category,
    required this.sourceID,
    required this.sortBy,
  });

  List<Object?> get props => [sourceID, category, sortBy];
}

class RefreshNewsEvent extends NewsEvent {
  final AllNewsResponse data;
  final int? sortBy;
  final int? category;
  RefreshNewsEvent({
    required this.data,
    required this.sortBy,
    required this.category,
  });

  List<Object?> get props => [
        data,
        sortBy,
        category,
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
