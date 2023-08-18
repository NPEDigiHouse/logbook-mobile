import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/domain/usecases/supervisor_usecases/get_all_supervisors_usecase.dart';
import 'package:equatable/equatable.dart';

part 'supervisors_state.dart';

class SupervisorsCubit extends Cubit<SupervisorsState> {
  final GetAllSupervisorsUsecase getAllSupervisorsUsecase;
  SupervisorsCubit({
    required this.getAllSupervisorsUsecase,
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
}
