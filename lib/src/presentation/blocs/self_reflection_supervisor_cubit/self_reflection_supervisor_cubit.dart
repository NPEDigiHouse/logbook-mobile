import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/self_reflection_datasource.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_model.dart';
import 'package:elogbook/src/data/models/self_reflection/student_self_reflection_model.dart';
import 'package:elogbook/src/data/models/self_reflection/verify_self_reflection_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:equatable/equatable.dart';

part 'self_reflection_supervisor_state.dart';

class SelfReflectionSupervisorCubit
    extends Cubit<SelfReflectionSupervisorState> {
  final SelfReflectionDataSource dataSource;
  SelfReflectionSupervisorCubit({required this.dataSource})
      : super(SelfReflectionSupervisorState());

  Future<void> getSelfReflections() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getSelfReflections();
      try {
        emit(state.copyWith(
          listData: result,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getDetailSelfReflections({required String id}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getStudentSelfReflection(studentId: id);
      try {
        emit(state.copyWith(
          data: result,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> verifySelfReflection(
      {required String id, required VerifySelfReflectionModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.verify(id: id, model: model);
      try {
        emit(state.copyWith(isVerify: true));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }
}
