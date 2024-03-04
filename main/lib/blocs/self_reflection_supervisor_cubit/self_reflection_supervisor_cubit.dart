import 'package:data/datasources/remote_datasources/self_reflection_datasource.dart';
import 'package:data/models/self_reflection/self_reflection_model.dart';
import 'package:data/models/self_reflection/student_self_reflection2_model.dart';
import 'package:data/models/self_reflection/verify_self_reflection_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'self_reflection_supervisor_state.dart';

class SelfReflectionSupervisorCubit
    extends Cubit<SelfReflectionSupervisorState> {
  final SelfReflectionDataSource dataSource;
  SelfReflectionSupervisorCubit({required this.dataSource})
      : super(SelfReflectionSupervisorState());

  Future<void> getSelfReflections() async {
    try {
      emit(state.copyWith(
        fetchState: RequestState.loading,
      ));

      final result = await dataSource.getSelfReflections(verified: false);
      emit(state.copyWith(listData: result, fetchState: RequestState.data));
    } catch (e) {
      emit(
        state.copyWith(
          fetchState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getSelfReflectionsVerified() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getSelfReflections(verified: true);
      emit(state.copyWith(listData2: result, requestState: RequestState.data));
    } catch (e) {
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
        detailState: RequestState.loading,
      ));

      final result = await dataSource.getDetail(id: id);
      emit(state.copyWith(data: result, detailState: RequestState.data));
    } catch (e) {
      emit(
        state.copyWith(
          detailState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getDetailSelfReflections2({required String id}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getStudentSelfReflection(studentId: id);
      try {
        emit(state.copyWith(
          data2: result,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  void reset() {
    emit(state.copyWith(requestStateVerifiy: RequestState.init));
  }

  Future<void> verifySelfReflection(
      {required String id, required VerifySelfReflectionModel model}) async {
    try {
      emit(state.copyWith(
        requestStateVerifiy: RequestState.loading,
      ));

      await dataSource.verify(id: id, model: model);
      try {
        emit(state.copyWith(
            isVerify: true, requestStateVerifiy: RequestState.data));
      } catch (e) {
        emit(state.copyWith(requestStateVerifiy: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestStateVerifiy: RequestState.error,
        ),
      );
    }
  }
}
