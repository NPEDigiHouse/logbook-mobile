import 'package:data/datasources/remote_datasources/supervisors_datasource.dart';
import 'package:data/datasources/remote_datasources/user_datasource.dart';
import 'package:data/models/supervisors/student_unit_model.dart';
import 'package:data/models/supervisors/supervisor_model.dart';
import 'package:data/models/supervisors/supervisor_student_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'supervisors_state.dart';

class SupervisorsCubit extends Cubit<SupervisorsState> {
  final SupervisorsDataSource dataSource;
  final UserDataSource profileDataSource;
  SupervisorsCubit({
    required this.dataSource,
    required this.profileDataSource,
  }) : super(SupervisorInit());

  Future<void> getAllSupervisors() async {
    try {
      emit(SupervisorLoading());

      final result = await dataSource.getAllSupervisors();

      result.fold((l) => emit(SupervisorFailed(message: l.message)),
          (r) => emit(SupervisorFetchSuccess(supervisors: r)));
    } catch (e) {
      emit(
        SupervisorFailed(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Uint8List?> getImageProfile({required String id}) async {
    final image = await profileDataSource.getProfilePic(userId: id);
    return image.fold((l) => null, (r) => r);
  }

  Future<void> getAllStudentDepartment({
    String? query,
    int? page,
    bool onScroll = false,
  }) async {
    try {
      final result = await dataSource.getAllStudentsByCeu(
        query: query,
        page: page,
      );

      // if (!onScroll) {
      //   emit(SupervisorLoading());
      // }

      List<StudentDepartmentModel> filteredStudents = result
          .where((element) => element.activeDepartmentId != null)
          .toList();

      if (page == 1 && !onScroll) {
        emit(FetchStudentDepartmentSuccess(students: filteredStudents));
      } else {
        if (state is FetchStudentDepartmentSuccess) {
          List<StudentDepartmentModel> existingStudents =
              (state as FetchStudentDepartmentSuccess).students;
          emit(FetchStudentDepartmentSuccess(
              students: [...existingStudents, ...filteredStudents]));
        }
      }
    } catch (e) {
      emit(
        SupervisorFailed(
          message: e.toString(),
        ),
      );
    }
  }
}
