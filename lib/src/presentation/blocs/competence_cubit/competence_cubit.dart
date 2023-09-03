import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/competence_datasource.dart';
import 'package:elogbook/src/data/models/competences/case_post_model.dart';
import 'package:elogbook/src/data/models/competences/list_cases_model.dart';
import 'package:elogbook/src/data/models/competences/list_skills_model.dart';
import 'package:elogbook/src/data/models/competences/list_student_cases_model.dart';
import 'package:elogbook/src/data/models/competences/list_student_skills_model.dart';
import 'package:elogbook/src/data/models/competences/skill_post_model.dart';
import 'package:elogbook/src/data/models/competences/student_competence_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'competence_state.dart';

class CompetenceCubit extends Cubit<CompetenceState> {
  final CompetenceDataSource competenceDataSource;

  CompetenceCubit({required this.competenceDataSource})
      : super(CompetenceState());

  Future<void> getListSkills() async {
    try {
      emit(state.copyWith(
        addSkillState: RequestState.loading,
      ));

      final result = await competenceDataSource.getListSkill();

      try {
        emit(state.copyWith(
          listSkillsModel: result,
          addSkillState: RequestState.data,
        ));
      } catch (e) {
        emit(state.copyWith(addSkillState: RequestState.error));
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

  Future<void> getListCases() async {
    try {
      emit(state.copyWith(
        addCaseState: RequestState.loading,
      ));

      final result = await competenceDataSource.getListCase();

      try {
        emit(state.copyWith(
          listCasesModel: result,
          addCaseState: RequestState.data,
        ));
      } catch (e) {
        emit(state.copyWith(addCaseState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          addCaseState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getStudentSkills({required String unitId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await competenceDataSource.getStudentSkills(unitId: unitId);

      try {
        emit(state.copyWith(
          studentSkillsModel: result,
          requestState: RequestState.data,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          addSkillState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getStudentCases({required String unitId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await competenceDataSource.getStudentCases(unitId: unitId);

      try {
        emit(state.copyWith(
          studentCasesModel: result,
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

  Future<void> uploadNewCase({required CasePostModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await competenceDataSource.addCase(
        casePostModel: model,
      );

      try {
        emit(state.copyWith(
          isCaseSuccessAdded: true,
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

  Future<void> uploadNewSkills({required SkillPostModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await competenceDataSource.addSkill(
        skillPostModel: model,
      );

      try {
        emit(state.copyWith(
          isSkillSuccessAdded: true,
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

  Future<void> getCaseStudents() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await competenceDataSource.getCaseListStudent();

      try {
        emit(state.copyWith(
          caseListStudent: result,
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

  Future<void> getSkillStudents() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await competenceDataSource.getSkillListStudent();

      try {
        emit(state.copyWith(
          skillListStudent: result,
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

  Future<void> getCasesByStudentId({required String studentId}) async {
    try {
      emit(state.copyWith(listCasesModel: null));
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await competenceDataSource.getListCaseOfStudent(studentId: studentId);

      try {
        emit(state.copyWith(
          listCasesModel: result,
          requestState: RequestState.data,
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

  Future<void> getSkillsByStudentId({required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await competenceDataSource.getListSkillOfStudent(
          studentId: studentId);

      try {
        emit(state.copyWith(
            listSkillsModel: result, requestState: RequestState.data));
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

  Future<void> verifyCaseById({required String id, required int rating}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await competenceDataSource.verifyCaseById(id: id, rating: rating);

      try {
        emit(state.copyWith(
          isCaseSuccessVerify: true,
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

  Future<void> verifySkillById(
      {required String id, required int rating}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await competenceDataSource.verifySkillById(id: id, rating: rating);

      try {
        emit(state.copyWith(
          isSkillSuccessVerify: true,
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

  Future<void> verifyAllSkillOfStudent({required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await competenceDataSource.verifyAllSkills(studentId: studentId);

      try {
        emit(state.copyWith(
          isAllSkillsSuccessVerify: true,
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

  Future<void> verifyAllCaseOfStudent({required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await competenceDataSource.verifyAllCases(studentId: studentId);

      try {
        emit(state.copyWith(
          isAllCasesSuccessVerify: true,
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
}
