import 'package:data/datasources/remote_datasources/sglcst_datasource.dart';
import 'package:data/datasources/remote_datasources/student_datasource.dart';
import 'package:data/utils/filter_type.dart';
import 'package:data/models/history/history_cst_model.dart';
import 'package:data/models/history/history_sgl_model.dart';
import 'package:data/models/sglcst/cst_model.dart';
import 'package:data/models/sglcst/sgl_cst_on_list_model.dart';
import 'package:data/models/sglcst/sgl_model.dart';
import 'package:data/models/sglcst/sglcst_post_model.dart';
import 'package:data/models/sglcst/topic_model.dart';
import 'package:data/models/sglcst/topic_post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'sgl_cst_state.dart';

class SglCstCubit extends Cubit<SglCstState> {
  final SglCstDataSource dataSource;
  final StudentDataSource studentDataSource;
  SglCstCubit({
    required this.dataSource,
    required this.studentDataSource,
  }) : super(SglCstState());

  void reset() {
    emit(state.copyWith(isCstEditSuccess: false, isSglEditSuccess: false));
  }

  // SGL

  Future<void> uploadSgl({required SglCstPostModel model}) async {
    emit(state.copyWith(
      createState: RequestState.loading,
    ));

    final result = await dataSource.uploadSgl(
      postModel: model,
    );
    result.fold(
      (l) => emit(state.copyWith(
        createState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) {
        emit(state.copyWith(
            isSglPostSuccess: true, createState: RequestState.data));
        getStudentSglDetail(status: 'INPROCESS');
      },
    );
  }

  Future<void> editSgl(
      {required id,
      int? startTime,
      int? endTime,
      String? date,
      List<Map<String, dynamic>>? topics}) async {
    emit(state.copyWith(
      createState: RequestState.loading,
    ));
    final result = await dataSource.editSgl(
      startTime: startTime,
      id: id,
      date: date,
      endTime: endTime,
      topics: topics,
    );
    result.fold(
      (l) => emit(state.copyWith(
        createState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) {
        emit(state.copyWith(
            isSglEditSuccess: true, createState: RequestState.data));
        getStudentSglDetail(status: "INPROCESS");
      },
    );
  }

  Future<void> deleteSgl({required String id}) async {
    emit(state.copyWith(
      fetchState: RequestState.loading,
    ));
    final result = await dataSource.deleteSgl(
      id: id,
    );
    result.fold(
      (l) => emit(state.copyWith(
        fetchState: RequestState.init,
        errorMessage: l.message,
      )),
      (r) {
        emit(state.copyWith(
            isSglDeleteSuccess: true, fetchState: RequestState.init));
        getStudentSglDetail(status: "INPROCESS");
      },
    );
  }

  Future<void> getSgl({required String id}) async {
    emit(state.copyWith(
      fetchState: RequestState.loading,
    ));
    final result = await dataSource.getSgl(
      id: id,
    );
    result.fold(
      (l) => emit(state.copyWith(
        fetchState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) => emit(
          state.copyWith(historySglData: r, fetchState: RequestState.data)),
    );
  }

  Future<void> getStudentSglDetail({required String status}) async {
    try {
      emit(state.copyWith(
        fetchState: RequestState.loading,
      ));

      final result = await studentDataSource.getStudentSgl(status: status);
      try {
        if (status == "VERIFIED") {
          emit(state.copyWith(
              sglDoneDetail: result, fetchState: RequestState.data));
        } else {
          emit(
              state.copyWith(sglDetail: result, fetchState: RequestState.data));
        }
      } catch (e) {
        emit(state.copyWith(
            fetchState: RequestState.error,
            errorMessage: 'Failed to load sgl'));
      }
    } catch (e) {
      emit(
        state.copyWith(
            fetchState: RequestState.error, errorMessage: 'Failed to load sgl'),
      );
    }
  }

  Future<void> addNewSglTopic(
      {required String sglId, required TopicPostModel topicModel}) async {
    emit(state.copyWith(
      createState: RequestState.loading,
    ));
    final result =
        await dataSource.addNewSglTopic(sglId: sglId, topic: topicModel);
    result.fold(
      (l) => emit(state.copyWith(
        createState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) {
        emit(state.copyWith(
          isNewTopicAddSuccess: true,
          createState: RequestState.data,
        ));
        getStudentSglDetail(status: 'INPROCESS');
      },
    );
  }

  Future<void> getListSglStudents({
    String? unitId,
    int? page,
    String? query,
    bool onScroll = false,
    FilterType? type,
  }) async {
    if (!onScroll) emit(state.copyWith(sglState: RequestState.loading));
    final result = await dataSource.getSglBySupervisor(
        unitId: unitId,
        query: query,
        page: page,
        filterType: type ?? FilterType.unverified);
    result.fold(
      (l) => emit(state.copyWith(
        sglState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) {
        if (page == 1 && !onScroll) {
          emit(state.copyWith(sglStudents: r, sglState: RequestState.data));
        } else {
          emit(state.copyWith(sglStudents: state.sglStudents! + r));
        }
      },
    );
  }

  Future<void> verifySglTopic(
      {required String topicId, required bool status}) async {
    emit(state.copyWith(
      requestState: RequestState.loading,
    ));

    final result =
        await dataSource.verifySglBySupervisor(id: topicId, status: status);
    result.fold(
      (l) => emit(state.copyWith(
        requestState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) => emit(state.copyWith(isVerifyTopicSuccess: true)),
    );
  }

  Future<void> verifySgl({required String sglId, required bool status}) async {
    emit(state.copyWith(
      requestState: RequestState.loading,
    ));

    final result = await dataSource.verifySglByCeu(id: sglId, status: status);
    result.fold(
      (l) => emit(state.copyWith(
        requestState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) => emit(state.copyWith(isVerifyTopicSuccess: true)),
    );
  }

  Future<void> getStudentSglDetailById({required String studentId}) async {
    emit(state.copyWith(
      requestState: RequestState.loading,
    ));

    final result = await dataSource.getSglByStudentId(studentId: studentId);
    result.fold(
      (l) => emit(state.copyWith(
        requestState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) => emit(state.copyWith(sglDetail: r)),
    );
  }

  Future<void> verifyAllSglTopic(
      {required String topicId, required bool status}) async {
    emit(state.copyWith(
      requestState: RequestState.loading,
    ));

    final result =
        await dataSource.verifyAllSglBySupervisor(id: topicId, status: status);
    result.fold(
      (l) => emit(state.copyWith(
        requestState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) {
        emit(state.copyWith(isVerifyAllSglCstSuccess: true));
      },
    );
  }

  // CST
  Future<void> uploadCst({required SglCstPostModel model}) async {
    emit(state.copyWith(
      createState: RequestState.loading,
    ));

    final result = await dataSource.uploadCst(
      postModel: model,
    );
    result.fold(
      (l) => emit(state.copyWith(
        createState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) {
        emit(state.copyWith(
            isCstPostSuccess: true, createState: RequestState.data));
        getStudentCstDetail(status: 'INPROCESS');
      },
    );
  }

  Future<void> getCst({required String id}) async {
    emit(state.copyWith(
      fetchState: RequestState.loading,
    ));
    final result = await dataSource.getCst(
      id: id,
    );
    result.fold(
      (l) => emit(state.copyWith(
        fetchState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) => emit(
          state.copyWith(historyCstData: r, fetchState: RequestState.data)),
    );
  }

  Future<void> editCst(
      {required id,
      int? startTime,
      int? endTime,
      String? date,
      List<Map<String, dynamic>>? topics}) async {
    emit(state.copyWith(
      createState: RequestState.loading,
    ));
    final result = await dataSource.editCst(
      startTime: startTime,
      id: id,
      endTime: endTime,
      topics: topics,
      date: date,
    );
    result.fold(
      (l) => emit(state.copyWith(
        createState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) {
        emit(state.copyWith(
            isCstEditSuccess: true, createState: RequestState.data));
        getStudentCstDetail(status: "INPROCESS");
      },
    );
  }

  Future<void> deleteCst({required String id}) async {
    final result = await dataSource.deleteCst(
      id: id,
    );
    result.fold(
      (l) => emit(state.copyWith(errorMessage: l.message)),
      (r) {
        emit(state.copyWith(isCstDeleteSuccess: true));
        getStudentCstDetail(status: "INPROCESS");
      },
    );
  }

  Future<void> addNewCstTopic(
      {required String cstId, required TopicPostModel topicModel}) async {
    emit(state.copyWith(
      createState: RequestState.loading,
    ));
    final result =
        await dataSource.addNewCstTopic(cstId: cstId, topic: topicModel);
    result.fold(
      (l) => emit(state.copyWith(
        createState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) {
        emit(state.copyWith(
          isNewTopicAddSuccess: true,
          createState: RequestState.data,
        ));
        getStudentCstDetail(status: 'INPROCESS');
      },
    );
  }

  Future<void> getTopics() async {
    emit(state.copyWith(
      requestState: RequestState.loading,
    ));

    final result = await dataSource.getTopics();
    result.fold(
      (l) => emit(state.copyWith(
        requestState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) => emit(state.copyWith(topics: r)),
    );
  }

  Future<void> getTopicsByDepartmentId({required String unitId}) async {
    final result = await dataSource.getTopicsByDepartmentId(unitId: unitId);
    result.fold(
      (l) => emit(state.copyWith(
        requestState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) => emit(state.copyWith(topics: r)),
    );
  }

  Future<void> getStudentCstDetail({required String status}) async {
    try {
      emit(state.copyWith(
        fetchState: RequestState.loading,
      ));

      final result = await studentDataSource.getStudentCst(status: status);
      if (status == "VERIFIED") {
        emit(state.copyWith(
            cstDoneDetail: result, fetchState: RequestState.data));
      } else {
        emit(state.copyWith(cstDetail: result, fetchState: RequestState.data));
      }
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'failed fetch cst',
          fetchState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getListCstStudents(
      {String? unitId,
      int? page,
      String? query,
      bool onScroll = false,
      FilterType? type}) async {
    if (!onScroll) emit(state.copyWith(cstState: RequestState.loading));

    final result = await dataSource.getCstBySupervisor(
        unitId: unitId,
        query: query,
        page: page,
        filterType: type ?? FilterType.unverified);
    result.fold(
      (l) => emit(state.copyWith(
        cstState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) {
        if (page == 1 && !onScroll) {
          emit(state.copyWith(cstStudents: r, cstState: RequestState.data));
        } else {
          emit(state.copyWith(
            cstStudents: state.cstStudents! + r,
            cstState: RequestState.error,
          ));
        }
      },
    );
  }

  Future<void> verifyCstTopic(
      {required String topicId, required bool status}) async {
    emit(state.copyWith(
      requestState: RequestState.loading,
    ));

    final result =
        await dataSource.verifyCstBySupervisor(id: topicId, status: status);

    result.fold(
      (l) => emit(state.copyWith(
        requestState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) => emit(state.copyWith(isVerifyTopicSuccess: true)),
    );
  }

  Future<void> verifyCst({required String cstId, required bool status}) async {
    emit(state.copyWith(
      requestState: RequestState.loading,
    ));

    final result = await dataSource.verifyCstByCeu(id: cstId, status: status);
    result.fold(
      (l) => emit(state.copyWith(
        requestState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) => emit(state.copyWith(isVerifyTopicSuccess: true)),
    );
  }

  Future<void> getStudentCstDetailById({required String studentId}) async {
    emit(state.copyWith(
      requestState: RequestState.loading,
    ));

    final result = await dataSource.getCstByStudentId(studentId: studentId);
    result.fold(
      (l) => emit(state.copyWith(
        requestState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) => emit(state.copyWith(cstDetail: r)),
    );
  }

  Future<void> verifyAllCstTopic(
      {required String topicId, required bool status}) async {
    emit(state.copyWith(
      requestState: RequestState.loading,
    ));

    final result =
        await dataSource.verifyAllCstBySupervisor(id: topicId, status: status);
    result.fold(
      (l) => emit(state.copyWith(
        requestState: RequestState.error,
        errorMessage: l.message,
      )),
      (r) {
        emit(state.copyWith(isVerifyAllSglCstSuccess: true));
      },
    );
  }
}
