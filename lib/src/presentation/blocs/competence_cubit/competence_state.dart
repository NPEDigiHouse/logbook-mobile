part of 'competence_cubit.dart';

class CompetenceState {
  final bool isSkillSuccessAdded;
  final bool isCaseSuccessAdded;
  final RequestState requestState;
  final List<StudentCaseModel>? studentCasesModel;
  final List<StudentSkillModel>? studentSkillsModel;
  final ListCasesModel? listCasesModel;
  final ListSkillsModel? listSkillsModel;

  CompetenceState({
    this.isSkillSuccessAdded = false,
    this.isCaseSuccessAdded = false,
    this.studentCasesModel,
    this.requestState = RequestState.init,
    this.studentSkillsModel,
    this.listCasesModel,
    this.listSkillsModel,
  });

  CompetenceState copyWith({
    RequestState requestState = RequestState.init,
    bool isSkillSuccessAdded = false,
    bool isCaseSuccessAdded = false,
    List<StudentCaseModel>? studentCasesModel,
    List<StudentSkillModel>? studentSkillsModel,
    ListCasesModel? listCasesModel,
    ListSkillsModel? listSkillsModel,
  }) {
    return CompetenceState(
      isSkillSuccessAdded: isSkillSuccessAdded,
      isCaseSuccessAdded: isCaseSuccessAdded,
      listCasesModel: listCasesModel ?? this.listCasesModel,
      listSkillsModel: listSkillsModel ?? this.listSkillsModel,
      studentCasesModel: studentCasesModel ?? this.studentCasesModel,
      studentSkillsModel: studentSkillsModel ?? this.studentSkillsModel,
    );
  }
}
