import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/competence_datasource.dart';
import 'package:elogbook/src/data/models/competences/case_post_model.dart';
import 'package:elogbook/src/data/models/competences/list_cases_model.dart';
import 'package:elogbook/src/data/models/competences/list_skills_model.dart';
import 'package:elogbook/src/data/models/competences/list_student_cases_model.dart';
import 'package:elogbook/src/data/models/competences/list_student_skills_model.dart';
import 'package:elogbook/src/data/models/competences/skill_post_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'competence_state.dart';

class CompetenceCubit extends Cubit<CompetenceState> {
  final CompetenceDataSource competenceDataSource;

  CompetenceCubit({required this.competenceDataSource})
      : super(CompetenceState());

  Future<void> getListSkills() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await competenceDataSource.getListSkill();

      try {
        emit(state.copyWith(
          listSkillsModel: result,
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

  Future<void> getListCases() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await competenceDataSource.getListCase();

      try {
        emit(state.copyWith(
          listCasesModel: result,
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
}
