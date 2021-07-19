part of "NewsBloc.dart";

class NewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNewsEvent extends NewsEvent {
  final int? category;
  FetchNewsEvent({required this.category});

  List<Object?> get props => [category];
}

class RefreshNewsEvent extends NewsEvent {
  final AllNewsResponse data;
  RefreshNewsEvent({required this.data});

  List<Object?> get props => [
        data,
      ];
}

class FetchNextNewsEvent extends NewsEvent {
  final int? category;
  FetchNextNewsEvent({required this.category});

  List<Object?> get props => [category];
}
