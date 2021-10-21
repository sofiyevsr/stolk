import 'package:stolk/logic/blocs/sourcesBloc/models/sourcesModel.dart';
import 'package:stolk/utils/@types/response/allSources.dart';
import 'package:stolk/utils/common.dart';
import 'package:stolk/utils/services/server/sourceService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:equatable/equatable.dart";

part "SourcesEvents.dart";
part "SourcesState.dart";

final service = SourceService();

class SourcesBloc extends Bloc<SourcesEvent, SourcesState> {
  SourcesBloc() : super(SourcesStateInitial());

  @override
  Stream<SourcesState> mapEventToState(SourcesEvent event) async* {
    if (event is FetchSourcesEvent) {
      try {
        yield SourcesStateLoading();
        final data = await service.getAllSources();
        if (data.sources.length > 0)
          yield SourcesStateSuccess(
            data: SourcesModel(
              sources: data.sources,
            ),
          );
        else
          yield SourcesStateNoData();
      } catch (e) {
        yield SourcesStateError();
      }
    }
    if (event is ToggleSourceFollow && state is SourcesStateSuccess) {
      final s = (state as SourcesStateSuccess);
      final item =
          s.data.sources.firstWhere((element) => element.id == event.id);
      SingleSource modifyItem = item.copyWith(
        isRequestOn: true,
      );
      yield SourcesStateSuccess(
        data: s.data.modifySingle(item: modifyItem, id: event.id),
      );
      try {
        if (item.followID != null) {
          await service.unfollow(item.id);
          modifyItem = item.copyWith(
            followID: Nullable<int>(value: null),
            isRequestOn: false,
          );
        } else {
          await service.follow(item.id);
          modifyItem = item.copyWith(
            followID: Nullable<int>(value: 0),
            isRequestOn: false,
          );
        }
      } catch (e) {
        modifyItem = item.copyWith(
          isRequestOn: false,
        );
      }

      yield SourcesStateSuccess(
        data: s.data.modifySingle(item: modifyItem, id: event.id),
      );
    }
  }
}
