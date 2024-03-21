import 'package:data/datasources/remote_datasources/competence_datasource.dart';
import 'package:data/datasources/remote_datasources/sglcst_datasource.dart';
import 'package:data/datasources/remote_datasources/unit_datasource.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:data/models/units/student_unit_model.dart';
import 'package:data/models/units/unit_model.dart';
import 'package:data/repository/repository_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/helpers/helper.dart';

part 'unit_state.dart';

class DepartmentCubit extends Cubit<DepartmentState> {
  final DepartmentDatasource datasource;
  final SglCstDataSource sglCstdataSource;
  final CompetenceDataSource competenceDataSource;
  DepartmentCubit({
    required this.datasource,
    required this.sglCstdataSource,
    required this.competenceDataSource,
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
        (r) => _updateFetchStaticData(),
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
        const CheckOutFailed(
          message: 'Cannot checkout finish all activities first',
        ),
      );
      getActiveDepartment();
    }
  }

  void _updateFetchStaticData() async {
    RepositoryData.unitClear();
    final department = await datasource.getActiveDepartment();
    department.fold((l) => null, (r) async {
      final sglcst = await sglCstdataSource.getTopicsByDepartmentId(
          unitId: r.unitId ?? '');
      final cases =
          await competenceDataSource.getStudentCases(unitId: r.unitId ?? '');
      final skills =
          await competenceDataSource.getStudentSkills(unitId: r.unitId ?? '');
      sglcst.fold((l) => null, (it) {
        RepositoryData.sglTopics.clear();
        RepositoryData.sglTopics
            .addAll(ParseHelper.filterTopic(listData: it, isSGL: true));
        RepositoryData.cstTopics.clear();
        RepositoryData.cstTopics
            .addAll(ParseHelper.filterTopic(listData: it, isSGL: false));
      });
      RepositoryData.cases = cases;
      RepositoryData.skills = skills;
    });
    emit(ChangeActiveSuccess());
  }
}
