part of 'special_report_cubit.dart';

class SpecialReportState {
  final SpecialReportResponse? specialReport;
  final SpecialReportDetail? specialReportDetail;
  final List<SpecialReportOnList>? specialReportStudents;
  final bool isVerifySpecialReportSuccess;
  final bool isSuccessPostSpecialReport;

  SpecialReportState({
    this.specialReport,
    this.specialReportDetail,
    this.isVerifySpecialReportSuccess = false,
    this.specialReportStudents,
    this.isSuccessPostSpecialReport = false,
  });

  SpecialReportState copyWith({
    RequestState? requestState,
    SpecialReportResponse? specialReport,
    SpecialReportDetail? specialReportDetail,
    bool isVerifySpecialReportSuccess = false,
    List<SpecialReportOnList>? specialReportStudents,
    bool isSuccessPostSpecialReport = false,
  }) {
    return SpecialReportState(
      specialReport: specialReport ?? this.specialReport,
      specialReportDetail: specialReportDetail ?? this.specialReportDetail,
      isSuccessPostSpecialReport: isSuccessPostSpecialReport,
      isVerifySpecialReportSuccess: isVerifySpecialReportSuccess,
      specialReportStudents:
          specialReportStudents ?? this.specialReportStudents,
    );
  }
}
