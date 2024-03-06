import 'package:data/datasources/remote_datasources/history_datasource.dart';
import 'package:data/models/history/history_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

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

  Future<void> getInOutHistories() async {
    try {
      emit(state.copyWith(requestStateIo: RequestState.loading));

      final data = await dataSource.getInOutHistory();
      emit(state.copyWith(historiesIo: data, requestStateIo: RequestState.data));
    } catch (e) {
      emit(state.copyWith(requestStateIo: RequestState.error));
    }
  }
}
