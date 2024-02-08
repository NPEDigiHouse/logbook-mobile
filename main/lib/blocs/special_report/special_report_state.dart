part of 'special_report_cubit.dart';

class SpecialReportState {
  final SpecialReportResponse? specialReport;
  final SpecialReportDetail? specialReportDetail;
  final List<SpecialReportOnList>? specialReportStudents;
  final List<SpecialReportOnList>? specialReportStudentsVerified;
  final bool isVerifySpecialReportSuccess;
  final bool isSuccessPostSpecialReport;
  final bool isDeleteSpecialReport;
  final bool isUpdateSpecialReport;

  SpecialReportState({
    this.specialReport,
    this.specialReportDetail,
    this.isVerifySpecialReportSuccess = false,
    this.specialReportStudents,
    this.specialReportStudentsVerified,
    this.isSuccessPostSpecialReport = false,
    this.isDeleteSpecialReport = false,
    this.isUpdateSpecialReport = false,
  });

  SpecialReportState copyWith({
    RequestState? requestState,
    SpecialReportResponse? specialReport,
    SpecialReportDetail? specialReportDetail,
    bool isVerifySpecialReportSuccess = false,
    List<SpecialReportOnList>? specialReportStudents,
    List<SpecialReportOnList>? specialReportStudentsVerified,
    bool isSuccessPostSpecialReport = false,
    bool isUpdateSpecialReport = false,
    bool isDeleteSpecialReport = false,
  }) {
    return SpecialReportState(
      specialReport: specialReport ?? this.specialReport,
      specialReportDetail: specialReportDetail ?? this.specialReportDetail,
      isSuccessPostSpecialReport: isSuccessPostSpecialReport,
      isVerifySpecialReportSuccess: isVerifySpecialReportSuccess,
      isDeleteSpecialReport: isDeleteSpecialReport,
      isUpdateSpecialReport: isUpdateSpecialReport,
      specialReportStudents:
          specialReportStudents ?? this.specialReportStudents,
      specialReportStudentsVerified:
          specialReportStudentsVerified ?? this.specialReportStudentsVerified,
    );
  }
}
