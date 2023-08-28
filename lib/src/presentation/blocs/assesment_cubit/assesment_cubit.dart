import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/assesment_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/student_datasource.dart';
import 'package:elogbook/src/data/models/assessment/list_scientific_assignment.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_detail_model.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_list_model.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_post_model.dart';
import 'package:elogbook/src/data/models/assessment/personal_behavior_detail.dart';
import 'package:elogbook/src/data/models/assessment/student_mini_cex.dart';
import 'package:elogbook/src/data/models/assessment/student_scientific_assignment.dart';
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

  Future<void> uploadScientificAssignment(
      {required MiniCexPostModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.addScientificAssignment(model: model);
      try {
        emit(state.copyWith(isUploadAssignmentSuccess: true));
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

  Future<void> getScientiicAssignmentDetail({required String id}) async {
    try {
      emit(state.copyWith(
        stateSa: RequestState.loading,
      ));

      final data = await dataSource.getScientificAssignmentDetail(id: id);
      try {
        emit(
          state.copyWith(
              scientificAssignmentDetail: data, stateSa: RequestState.data),
        );
      } catch (e) {
        emit(state.copyWith(stateSa: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          stateSa: RequestState.error,
        ),
      );
    }
  }

  Future<void> assesmentScientificAssignment(
      {required String id, required Map<String, dynamic> sa}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));
      await dataSource.addScoreScientificAssignment(id: id, score: sa);
      try {
        emit(state.copyWith(
          isAssementScientificAssignmentSuccess: true,
          scientificAssignmentDetail: null,
          stateSa: RequestState.loading,
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

  Future<void> studentScientificAssignment({required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final data =
          await dataSource.getStudentScientificAssignment(studentId: studentId);
      try {
        emit(state.copyWith(scientificAssignmentStudents: data));
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

  Future<void> getStudentScientificAssignment() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final data = await studentDataSource.getStudentScientificAssignment();
      try {
        emit(state.copyWith(scientificAssignmentStudents: data));
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

  Future<void> getPersonalBehaviorByStudentId(
      {required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final data = await dataSource.getStudentPersonalBehavior(
        studentId: studentId,
      );
      try {
        emit(state.copyWith(personalBehaviorStudent: data));
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

  Future<void> getStudentPersonalBehavior() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final data = await studentDataSource.getStudentPersonalBehavior();
      try {
        emit(state.copyWith(personalBehaviorStudent: data));
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

  Future<void> verifyPersonalBehavior(
      {required int id, required bool isVerified, required String pbId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));
      await dataSource.verifyPersonalBehavior(
          id: id, status: isVerified, pbId: pbId);
      try {
        emit(state.copyWith(
          isPersonalBehaviorVerify: true,
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

  Future<void> getPersonalBehaviorDetail({required String id}) async {
    try {
      emit(state.copyWith(
        stateSa: RequestState.loading,
      ));

      final data = await dataSource.getPersonalBehaviorDetail(id: id);
      try {
        emit(
          state.copyWith(
            personalBehaviorDetail: data,
          ),
        );
      } catch (e) {
        emit(state.copyWith(stateSa: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          stateSa: RequestState.error,
        ),
      );
    }
  }
}
