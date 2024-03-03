import 'package:data/datasources/remote_datasources/competence_datasource.dart';
import 'package:data/models/competences/case_post_model.dart';
import 'package:data/models/competences/list_cases_model.dart';
import 'package:data/models/competences/list_skills_model.dart';
import 'package:data/models/competences/list_student_cases_model.dart';
import 'package:data/models/competences/list_student_skills_model.dart';
import 'package:data/models/competences/skill_post_model.dart';
import 'package:data/models/competences/student_competence_model.dart';
import 'package:data/utils/filter_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'competence_state.dart';

class CompetenceCubit extends Cubit<CompetenceState> {
  final CompetenceDataSource competenceDataSource;

  CompetenceCubit({required this.competenceDataSource})
      : super(CompetenceState());

  void reset() {
    emit(state.copyWith(
        isSkillSuccessVerify: false,
        isAllSkillsSuccessVerify: false,
        isSkillSuccessAdded: false,
        isAllCasesSuccessVerify: false));
  }

  Future<void> getListSkills() async {
    try {
      emit(state.copyWith(
        fetchState: RequestState.loading,
      ));

      final result = await competenceDataSource.getListSkill();

      emit(state.copyWith(
        listSkillsModel: result,
        fetchState: RequestState.data,
      ));
    } catch (e) {
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
        fetchState: RequestState.loading,
      ));

      final result = await competenceDataSource.getListCase();

      emit(state.copyWith(
        listCasesModel: result,
        fetchState: RequestState.data,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          fetchState: RequestState.error,
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
        addCaseState: RequestState.loading,
      ));

      await competenceDataSource.addCase(
        casePostModel: model,
      );

      emit(state.copyWith(
          isCaseSuccessAdded: true, addCaseState: RequestState.data));
      getListCases();
    } catch (e) {
      emit(
        state.copyWith(
          addCaseState: RequestState.error,
        ),
      );
    }
  }

  Future<void> uploadNewSkills({required SkillPostModel model}) async {
    try {
      emit(state.copyWith(
        addSkillState: RequestState.loading,
      ));
      await competenceDataSource.addSkill(
        skillPostModel: model,
      );
      emit(state.copyWith(
        isSkillSuccessAdded: true,
        addSkillState: RequestState.data,
      ));
      getListSkills();
    } catch (e) {
      emit(
        state.copyWith(
          addSkillState: RequestState.error,
        ),
      );
    }
  }

  Future<void> updateSkill(
      {required SkillPostModel model, required String id}) async {
    try {
      emit(state.copyWith(
        addSkillState: RequestState.loading,
      ));

      await competenceDataSource.updateSkill(skillPostModel: model, id: id);

      emit(state.copyWith(
        isSkillSuccessAdded: true,
        addSkillState: RequestState.data,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          addSkillState: RequestState.error,
        ),
      );
    }
  }

  Future<void> updateCase(
      {required CasePostModel model, required String id}) async {
    try {
      emit(state.copyWith(
        addCaseState: RequestState.loading,
      ));

      await competenceDataSource.updateCase(casePostModel: model, id: id);

      emit(state.copyWith(
        isCaseSuccessAdded: true,
        addCaseState: RequestState.data,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          addCaseState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getCaseStudents(
      {String? unitId,
      int? page,
      String? query,
      bool onScroll = false,
      FilterType? type}) async {
    try {
      final result = await competenceDataSource.getCaseListStudent(
        filterType: type ?? FilterType.unverified,
        page: page,
        query: query,
        unitId: unitId,
      );
      if (!onScroll) emit(state.copyWith(fetchState: RequestState.loading));

      if (page == 1 && !onScroll) {
        emit(state.copyWith(
            caseListStudent: result, fetchState: RequestState.data));
      } else {
        emit(state.copyWith(
            caseListStudent: result + state.caseListStudent!,
            fetchState: RequestState.data));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getSkillStudents(
      {String? unitId,
      int? page,
      String? query,
      bool onScroll = false,
      FilterType? type}) async {
    try {
      final result = await competenceDataSource.getSkillListStudent(
        filterType: type ?? FilterType.unverified,
        page: page,
        query: query,
        unitId: unitId,
      );
      if (!onScroll) emit(state.copyWith(fetchState: RequestState.loading));

      if (page == 1 && !onScroll) {
        emit(state.copyWith(
            skillListStudent: result, fetchState: RequestState.data));
      } else {
        emit(state.copyWith(
            skillListStudent: result + state.skillListStudent!,
            fetchState: RequestState.data));
      }
    } catch (e) {
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
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> deleteSkillById({required String id}) async {
    try {
      await competenceDataSource.deleteSkill(id);
      emit(state.copyWith(
        isDeleteSkillSuccess: true,
      ));
      getListSkills();
    } catch (e) {}
  }

  Future<void> deleteCaseById({required String id}) async {
    try {
      await competenceDataSource.deleteCase(id);

      emit(state.copyWith(
        isDeleteCaseSuccess: true,
      ));
      getListCases();
    } catch (e) {}
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
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }
}
