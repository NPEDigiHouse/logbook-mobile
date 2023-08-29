part of 'reference_cubit.dart';

class ReferenceState {
  final List<ReferenceOnListModel>? references;
  final bool isSuccessDownload;

  ReferenceState({
    this.references,
    this.isSuccessDownload = false,
  });

  ReferenceState copyWith({
    RequestState? requestState,
    List<ReferenceOnListModel>? references,
    bool successVerifyClinicalRecords = false,
    bool isSuccessDownload = false,
  }) {
    return ReferenceState(
      references: references ?? this.references,
      isSuccessDownload: isSuccessDownload,
    );
  }
}
