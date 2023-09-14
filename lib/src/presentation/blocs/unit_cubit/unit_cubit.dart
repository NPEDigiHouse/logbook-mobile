import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/unit_datasource.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/data/models/units/unit_model.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/change_unit_active_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/check_in_active_unit_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/fetch_units_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/get_active_unit_usecase.dart';
import 'package:equatable/equatable.dart';

part 'unit_state.dart';

class DepartmentCubit extends Cubit<DepartmentState> {
  final FetchDepartmentsUsecase fetchDepartmentsUsecase;
  final ChangeActiveDepartmentUsecase changeActiveDepartmentUsecase;
  final GetActiveDepartmentUsecase getActiveDepartmentUsecase;
  final CheckInActiveDepartmentUsecase checkInActiveDepartmentUsecase;
  final DepartmentDatasource datasource;
  DepartmentCubit({
    required this.fetchDepartmentsUsecase,
    required this.changeActiveDepartmentUsecase,
    required this.getActiveDepartmentUsecase,
    required this.checkInActiveDepartmentUsecase,
    required this.datasource,
  }) : super(Initial());

  Future<void> fetchDepartments(bool? isSortAZ) async {
    try {
      emit(Loading());

      final result = await fetchDepartmentsUsecase.execute();

      result.fold((l) => emit(Failed(message: l.message)), (r) {
        if (isSortAZ != null) {
          if (isSortAZ) {
            r.sort(
                (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          } else {
            r.sort(
                (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
          }
        }
        emit(FetchSuccess(units: r));
      });
    } catch (e) {
      print(e.toString());
      emit(
        Failed(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> changeDepartmentActive({required String unitId}) async {
    try {
      emit(Loading());

      final result =
          await changeActiveDepartmentUsecase.execute(unitId: unitId);

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

  Future<void> getActiveDepartment() async {
    try {
      emit(Loading());

      final result = await getActiveDepartmentUsecase.execute();

      result.fold(
        (l) => emit(Failed(message: l.message)),
        (r) => emit(GetActiveDepartmentSuccess(activeDepartment: r)),
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

  Future<void> checkInActiveDepartment() async {
    try {
      emit(Loading());

      final result = await checkInActiveDepartmentUsecase.execute();

      result.fold(
        (l) => emit(Failed(message: l.message)),
        (r) => emit(CheckInActiveDepartmentSuccess()),
      );
    } catch (e) {
      emit(
        Failed(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> checkOutActiveDepartment() async {
    try {
      emit(Loading());

      await datasource.checkOutActiveDepartment();

      emit(CheckOutActiveDepartmentSuccess());
    } catch (e) {
      emit(
        CheckOutFailed(
          message: 'Cannot checkout finish all activities first',
        ),
      );
      getActiveDepartment();
    }
  }
}
