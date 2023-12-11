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
  }) : super(Initial());

  Future<void> getAllSupervisors() async {
    try {
      emit(Loading());

      final result = await dataSource.getAllSupervisors();

      result.fold((l) => emit(Failed(message: l.message)),
          (r) => emit(FetchSuccess(supervisors: r)));
    } catch (e) {
      print(e.toString());
      emit(
        Failed(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Uint8List?> getImageProfile({required String id}) async {
    final image = await profileDataSource.getProfilePic(userId: id);
    return image.fold((l) => null, (r) => r);
  }

  Future<void> getAllStudentDepartment() async {
    try {
      emit(Loading());

      final result = await dataSource.getAllStudentsByCeu();

      emit(FetchStudentDepartmentSuccess(
          students: result
              .where(
                (element) => element.activeDepartmentId != null,
              )
              .toList()));
    } catch (e) {
      print(e.toString());
      emit(
        Failed(
          message: e.toString(),
        ),
      );
    }
  }
}
