import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/sglcst_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/student_datasource.dart';
import 'package:elogbook/src/data/models/sglcst/cst_model.dart';
import 'package:elogbook/src/data/models/sglcst/sgl_cst_on_list_model.dart';
import 'package:elogbook/src/data/models/sglcst/sgl_model.dart';
import 'package:elogbook/src/data/models/sglcst/sglcst_post_model.dart';
import 'package:elogbook/src/data/models/sglcst/topic_model.dart';
import 'package:elogbook/src/data/models/sglcst/topic_post_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

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

  Future<void> getTopicsByUnitId({required String unitId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getTopicsByUnitId(unitId: unitId);
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
        emit(
            state.copyWith(sglDetail: result, requestState: RequestState.data));
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
      {required String sglId, required TopicPostModel topicModel}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));
      await dataSource.addNewSglTopic(sglId: sglId, topic: topicModel);
      try {
        emit(state.copyWith(isNewTopicAddSuccess: true));
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

  Future<void> getStudentCstDetail() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await studentDataSource.getStudentCst();
      try {
        emit(
            state.copyWith(cstDetail: result, requestState: RequestState.data));
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

  Future<void> addNewCstTopic(
      {required String cstId, required TopicPostModel topicModel}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));
      await dataSource.addNewCstTopic(cstId: cstId, topic: topicModel);
      try {
        emit(state.copyWith(isNewTopicAddSuccess: true));
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

  Future<void> getListSglStudents() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getSglBySupervisor();
      try {
        emit(state.copyWith(sglStudents: result));
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

  Future<void> getListCstStudents() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getCstBySupervisor();
      try {
        emit(state.copyWith(cstStudents: result));
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

  Future<void> verifySglTopic(
      {required String topicId, required bool status}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.verifySglBySupervisor(id: topicId, status: status);
      try {
        emit(state.copyWith(isVerifyTopicSuccess: true));
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

  Future<void> verifyCstTopic(
      {required String topicId, required bool status}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.verifyCstBySupervisor(id: topicId, status: status);
      try {
        emit(state.copyWith(isVerifyTopicSuccess: true));
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

  Future<void> verifyCst({required String cstId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.verifyCstByCeu(id: cstId, status: true);
      try {
        emit(state.copyWith(isVerifyTopicSuccess: true));
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

  Future<void> verifySgl({required String sglId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.verifySglByCeu(id: sglId, status: true);
      try {
        emit(state.copyWith(isVerifyTopicSuccess: true));
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

  Future<void> getStudentCstDetailById({required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getCstByStudentId(studentId: studentId);
      try {
        emit(state.copyWith(cstDetail: result));
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

  Future<void> getStudentSglDetailById({required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getSglByStudentId(studentId: studentId);
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
}
