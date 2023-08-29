part of 'special_report_cubit.dart';

class SpecialReportState {
  final SpecialReportResponse? specialReport;
  final SpecialReportDetail? specialReportDetail;
  final bool isSuccessPostSpecialReport;

  SpecialReportState({
    this.specialReport,
    this.specialReportDetail,
    this.isSuccessPostSpecialReport = false,
  });

  SpecialReportState copyWith({
    RequestState? requestState,
    SpecialReportResponse? specialReport,
    SpecialReportDetail? specialReportDetail,
    bool isSuccessPostSpecialReport = false,
  }) {
    return SpecialReportState(
      specialReport: specialReport ?? this.specialReport,
      specialReportDetail: specialReportDetail ?? this.specialReportDetail,
      isSuccessPostSpecialReport: isSuccessPostSpecialReport,
    );
  }
}
