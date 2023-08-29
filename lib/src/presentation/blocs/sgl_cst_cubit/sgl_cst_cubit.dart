import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/sglcst_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/student_datasource.dart';
import 'package:elogbook/src/data/models/sglcst/sgl_model.dart';
import 'package:elogbook/src/data/models/sglcst/sglcst_post_model.dart';
import 'package:elogbook/src/data/models/sglcst/topic_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/features/students/sgl_cst/widgets/sgl_cst_data.dart';

part 'sgl_cst_state.dart';

class SglCstCubit extends Cubit<SglCstState> {
  final SglCstDataSource dataSource;
  final StudentDataSource studentDataSource;
  SglCstCubit({
    required this.dataSource,
    required this.studentDataSource,
  }) : super(SglCstState());

  Future<void> uploadSgl({required SglCstPostModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.uploadSgl(
        postModel: model,
      );
      try {
        emit(state.copyWith(isSglPostSuccess: true));
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

  Future<void> uploadCst({required SglCstPostModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.uploadCst(
        postModel: model,
      );
      try {
        emit(state.copyWith(isCstPostSuccess: true));
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

  Future<void> getTopics() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getTopics();
      try {
        emit(state.copyWith(
          topics: result,
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

  Future<void> getStudentSglDetail() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await studentDataSource.getStudentSgl();
      try {
        emit(state.copyWith(sglDetail: result));
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

  Future<void> addNewSglTopic(
      {required String sglId, required SglCstPostModel topicModel}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));
      await dataSource.addNewSglTopic(sglId: sglId, topic: topicModel);
      try {
        emit(state.copyWith(isNewSglTopicAddSuccess: true));
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
