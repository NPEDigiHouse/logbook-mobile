import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/history_datasource.dart';
import 'package:elogbook/src/data/models/history/history_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryDataSource dataSource;

  HistoryCubit({required this.dataSource}) : super(HistoryState());

  Future<void> getHistories() async {
    try {
      emit(state.copyWith(requestState: RequestState.loading));

      final data = await dataSource.getHistory();
      emit(state.copyWith(histories: data, requestState: RequestState.data));
    } catch (e) {
      emit(state.copyWith(requestState: RequestState.error));
    }
  }
}
