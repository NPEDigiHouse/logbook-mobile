import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/fetch_units_usecase.dart';
import 'package:equatable/equatable.dart';

part 'unit_state.dart';

class UnitCubit extends Cubit<UnitState> {
  final FetchUnitsUsecase fetchUnitsUsecase;
  UnitCubit({required this.fetchUnitsUsecase}) : super(Initial());

  Future<void> fetchUnits() async {
    try {
      emit(Loading());

      final result = await fetchUnitsUsecase.execute();

      result.fold((l) => emit(Failed(message: l.message)),
          (r) => emit(FetchSuccess(units: r)));
    } catch (e) {
      emit(Failed(message: e.toString()));
    }
  }
}
