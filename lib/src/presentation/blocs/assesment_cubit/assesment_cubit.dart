import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/assesment_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/student_datasource.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_detail_model.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_list_model.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_post_model.dart';
import 'package:elogbook/src/data/models/assessment/student_mini_cex.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'assesment_state.dart';

class AssesmentCubit extends Cubit<AssesmentState> {
  final AssesmentDataSource dataSource;
  final StudentDataSource studentDataSource;
  AssesmentCubit({required this.dataSource, required this.studentDataSource})
      : super(AssesmentState());

  Future<void> uploadMiniCex({required MiniCexPostModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.addMiniCex(model: model);
      try {
        emit(state.copyWith(isUploadMiniCexSuccess: true));
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

  Future<void> studentMiniCexs() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final data = await studentDataSource.getStudentMiniCex();
      try {
        emit(state.copyWith(studentMiniCexs: data));
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

  Future<void> studentMiniCex({required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final data = await dataSource.getStudetnMiniCex(studentId: studentId);
      try {
        emit(state.copyWith(studentMiniCex: data));
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

  Future<void> assesmentMiniCex(
      {required String id, required Map<String, dynamic> miniCex}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));
      await dataSource.addScoreMiniCex(minicexId: id, listItemRating: miniCex);
      try {
        emit(state.copyWith(isAssesmentMiniCexSuccess: true));
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

  Future<void> getMiniCexStudentDetail({required String id}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final data = await dataSource.getMiniCexDetail(id: id);
      try {
        emit(
          state.copyWith(
              miniCexStudentDetail: data, requestState: RequestState.data),
        );
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
