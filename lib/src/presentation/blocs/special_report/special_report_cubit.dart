import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/special_report_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/student_datasource.dart';
import 'package:elogbook/src/data/models/special_reports/special_report_detail.dart';
import 'package:elogbook/src/data/models/special_reports/special_report_response.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'special_report_state.dart';

class SpecialReportCubit extends Cubit<SpecialReportState> {
  final StudentDataSource studentDataSource;
  final SpecialReportDataSource specialReportDataSource;
  SpecialReportCubit(
      {required this.specialReportDataSource, required this.studentDataSource})
      : super(SpecialReportState());

  Future<void> getSpecialReportDetail({required String id}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await specialReportDataSource.getSpecialReportDetail(id: id);
      try {
        emit(state.copyWith(specialReportDetail: result));
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

  Future<void> getStudentSpecialReport() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await studentDataSource.getStudentSpecialReports();
      try {
        emit(state.copyWith(specialReport: result));
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

  Future<void> postSpecialReport({required String content}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await specialReportDataSource.postSpecialReport(content: content);
      try {
        emit(state.copyWith(isSuccessPostSpecialReport: true));
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
