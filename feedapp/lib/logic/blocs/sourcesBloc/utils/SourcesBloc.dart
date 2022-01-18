import 'package:bloc_concurrency/bloc_concurrency.dart';
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
  SourcesBloc() : super(SourcesStateInitial()) {
    on<FetchSourcesEvent>((event, emit) async {
      try {
        emit(SourcesStateLoading());
        final data = await service.getAllSources();
        if (data.sources.isNotEmpty)
          emit(SourcesStateSuccess(
            data: SourcesModel(
              sources: data.sources,
            ),
          ));
        else
          emit(SourcesStateNoData());
      } catch (e) {
        emit(SourcesStateError());
      }
    });
    on<ToggleSourceFollow>(
      (event, emit) async {
        if (state is! SourcesStateSuccess) return;
        final s = (state as SourcesStateSuccess);
        final item =
            s.data.sources.firstWhere((element) => element.id == event.id);
        SingleSource modifyItem = item.copyWith(
          isRequestOn: true,
        );
        emit(SourcesStateSuccess(
          data: s.data.modifySingle(item: modifyItem, id: event.id),
        ));
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

        emit(SourcesStateSuccess(
          data: s.data.modifySingle(item: modifyItem, id: event.id),
        ));
      },
      transformer: sequential(),
    );
  }
}
