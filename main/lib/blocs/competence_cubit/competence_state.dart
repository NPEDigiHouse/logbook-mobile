part of 'competence_cubit.dart';

class CompetenceState {
  final bool isSkillSuccessAdded;
  final bool isCaseSuccessAdded;
  final RequestState requestState;
  final RequestState skillState;
  final RequestState fetchState;
  final RequestState caseState;
  final List<StudentCaseModel>? studentCasesModel;
  final List<StudentSkillModel>? studentSkillsModel;
  final List<StudentCompetenceModel>? caseListStudent;
  final List<StudentCompetenceModel>? skillListStudent;
  final ListCasesModel? listCasesModel;
  final ListSkillsModel? listSkillsModel;
  final bool isSkillSuccessVerify;
  final bool isCaseSuccessVerify;
  final bool isAllCasesSuccessVerify;
  final bool isAllSkillsSuccessVerify;
  final bool isDeleteCaseSuccess;
  final bool isDeleteSkillSuccess;
  

  CompetenceState({
    this.isSkillSuccessAdded = false,
    this.isCaseSuccessAdded = false,
    this.studentCasesModel,
    this.fetchState = RequestState.init,
    this.caseState = RequestState.init,
    this.skillState = RequestState.init,
    this.requestState = RequestState.init,
    this.studentSkillsModel,
    this.listCasesModel,
    this.listSkillsModel,
    this.caseListStudent,
    this.isDeleteCaseSuccess = false,
    this.isDeleteSkillSuccess = false,
    this.skillListStudent,
    this.isSkillSuccessVerify = false,
    this.isCaseSuccessVerify = false,
    this.isAllCasesSuccessVerify = false,
    this.isAllSkillsSuccessVerify = false,
  });

  CompetenceState copyWith({
    RequestState requestState = RequestState.init,
    RequestState fetchState = RequestState.init,
    RequestState addSkillState = RequestState.init,
    RequestState addCaseState = RequestState.init,
    bool isSkillSuccessAdded = false,
    bool isCaseSuccessAdded = false,
    List<StudentCaseModel>? studentCasesModel,
    List<StudentSkillModel>? studentSkillsModel,
    ListCasesModel? listCasesModel,
    ListSkillsModel? listSkillsModel,
    List<StudentCompetenceModel>? caseListStudent,
    List<StudentCompetenceModel>? skillListStudent,
    bool isSkillSuccessVerify = false,
    bool isCaseSuccessVerify = false,
    bool isAllCasesSuccessVerify = false,
    bool isAllSkillsSuccessVerify = false,
    bool isDeleteCaseSuccess = false,
    bool isDeleteSkillSuccess = false,
  }) {
    return CompetenceState(
      isSkillSuccessAdded: isSkillSuccessAdded,
      isCaseSuccessAdded: isCaseSuccessAdded,
      fetchState: fetchState,
      listCasesModel: listCasesModel ?? this.listCasesModel,
      listSkillsModel: listSkillsModel ?? this.listSkillsModel,
      studentCasesModel: studentCasesModel ?? this.studentCasesModel,
      studentSkillsModel: studentSkillsModel ?? this.studentSkillsModel,
      caseListStudent: caseListStudent ?? this.caseListStudent,
      skillListStudent: skillListStudent ?? this.skillListStudent,
      requestState: requestState,
      isSkillSuccessVerify: isSkillSuccessVerify,
      isCaseSuccessVerify: isCaseSuccessVerify,
      isAllCasesSuccessVerify: isAllCasesSuccessVerify,
      isAllSkillsSuccessVerify: isAllSkillsSuccessVerify,
      caseState: addCaseState,
      skillState: addSkillState,
      isDeleteCaseSuccess: isDeleteCaseSuccess,
      isDeleteSkillSuccess: isDeleteSkillSuccess,
    );
  }
}
