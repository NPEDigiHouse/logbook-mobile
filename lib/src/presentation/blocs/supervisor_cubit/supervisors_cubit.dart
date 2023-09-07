import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/profile_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/supervisors_datasource.dart';
import 'package:elogbook/src/data/models/supervisors/student_unit_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';
import 'package:elogbook/src/domain/usecases/supervisor_usecases/get_all_supervisors_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'supervisors_state.dart';

class SupervisorsCubit extends Cubit<SupervisorsState> {
  final GetAllSupervisorsUsecase getAllSupervisorsUsecase;
  final SupervisorsDataSource dataSource;
  final ProfileDataSource profileDataSource;
  SupervisorsCubit({
    required this.getAllSupervisorsUsecase,
    required this.dataSource,
    required this.profileDataSource,
  }) : super(Initial());

  Future<void> getAllSupervisors() async {
    try {
      emit(Loading());

      final result = await getAllSupervisorsUsecase.execute();

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

  Future<Uint8List> getImageProfile({required String id}) async {
    final image = await profileDataSource.getProfilePic(userId: id);
    return image;
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
