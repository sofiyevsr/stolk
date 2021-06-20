part of "NewsBloc.dart";

class NewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNewsEvent extends NewsEvent {}

class FetchNextNewsEvent extends NewsEvent {
  // final String lastCreatedAt;
  // FetchNextCampaignsEvent({required this.lastCreatedAt});
}
