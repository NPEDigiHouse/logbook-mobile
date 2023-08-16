import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/change_unit_active_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/check_in_active_unit_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/fetch_units_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/get_active_unit_usecase.dart';
import 'package:equatable/equatable.dart';

part 'unit_state.dart';

class UnitCubit extends Cubit<UnitState> {
  final FetchUnitsUsecase fetchUnitsUsecase;
  final ChangeActiveUnitUsecase changeActiveUnitUsecase;
  final GetActiveUnitUsecase getActiveUnitUsecase;
  final CheckInActiveUnitUsecase checkInActiveUnitUsecase;
  UnitCubit({
    required this.fetchUnitsUsecase,
    required this.changeActiveUnitUsecase,
    required this.getActiveUnitUsecase,
    required this.checkInActiveUnitUsecase,
  }) : super(Initial());

  Future<void> fetchUnits() async {
    try {
      emit(Loading());

      final result = await fetchUnitsUsecase.execute();

      result.fold((l) => emit(Failed(message: l.message)),
          (r) => emit(FetchSuccess(units: r)));
    } catch (e) {
      print(e.toString());
      emit(
        Failed(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> changeUnitActive({required String unitId}) async {
    try {
      emit(Loading());

      final result = await changeActiveUnitUsecase.execute(unitId: unitId);

      result.fold(
        (l) => emit(ChangeActiveFailed()),
        (r) => emit(ChangeActiveSuccess()),
      );
    } catch (e) {
      emit(
        Failed(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> getActiveUnit() async {
    try {
      emit(Loading());

      final result = await getActiveUnitUsecase.execute();

      result.fold(
        (l) => emit(Failed(message: l.message)),
        (r) => emit(GetActiveUnitSuccess(activeUnit: r)),
      );
    } catch (e) {
      print("Error");
      emit(
        Failed(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> checkInActiveUnit() async {
    try {
      emit(Loading());

      final result = await checkInActiveUnitUsecase.execute();

      result.fold(
        (l) => emit(Failed(message: l.message)),
        (r) => emit(CheckInActiveUnitSuccess()),
      );
    } catch (e) {
      emit(
        Failed(
          message: e.toString(),
        ),
      );
    }
  }
}
