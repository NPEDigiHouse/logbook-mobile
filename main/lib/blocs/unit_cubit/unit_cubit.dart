import 'package:data/datasources/remote_datasources/unit_datasource.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:data/models/units/student_unit_model.dart';
import 'package:data/models/units/unit_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'unit_state.dart';

class DepartmentCubit extends Cubit<DepartmentState> {
  final DepartmentDatasource datasource;
  DepartmentCubit({
    required this.datasource,
  }) : super(Initial());

  Future<void> fetchDepartments(bool? isSortAZ) async {
    try {
      emit(Loading());

      final result = await datasource.fetchAllDepartment();

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
      emit(
        Failed(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> fetchStudentDepartments(bool? isSortAZ) async {
    try {
      emit(Loading());

      final result = await datasource.fetchStudentDepartment();

      result.fold((l) => emit(Failed(message: l.message)), (r) {
        if (isSortAZ != null) {
          if (isSortAZ) {
            r.units!.sort(
                (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          } else {
            r.units!.sort(
                (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
          }
        }
        emit(StudentUnitFetchSuccess(units: r));
      });
    } catch (e) {
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

      final result = await datasource.changeDepartmentActive(unitId: unitId);

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

      final result = await datasource.getActiveDepartment();

      result.fold(
        (l) => emit(Failed(message: l.message)),
        (r) => emit(GetActiveDepartmentSuccess(activeDepartment: r)),
      );
    } catch (e) {
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

      final result = await datasource.checkInActiveDepartment();

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