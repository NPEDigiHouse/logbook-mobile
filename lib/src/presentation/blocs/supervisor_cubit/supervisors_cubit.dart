import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/supervisors_datasource.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';
import 'package:elogbook/src/domain/usecases/supervisor_usecases/get_all_supervisors_usecase.dart';
import 'package:equatable/equatable.dart';

part 'supervisors_state.dart';

class SupervisorsCubit extends Cubit<SupervisorsState> {
  final GetAllSupervisorsUsecase getAllSupervisorsUsecase;
  final SupervisorsDataSource dataSource;
  SupervisorsCubit({
    required this.getAllSupervisorsUsecase,
    required this.dataSource,
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

  Future<void> getAllStudents() async {
    try {
      emit(Loading());

      final result = await dataSource.getAllStudents();

      emit(FetchStudentSuccess(students: result));
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
