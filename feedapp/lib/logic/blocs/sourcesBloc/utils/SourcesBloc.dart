import 'package:stolk/logic/blocs/sourcesBloc/models/sourcesModel.dart';
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
        print(e);
        yield SourcesStateError();
      }
    }
  }
}
