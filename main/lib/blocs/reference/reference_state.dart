part of 'reference_cubit.dart';

class ReferenceState {
  final List<ReferenceOnListModel>? references;
  final String? rData;

  ReferenceState({
    this.references,
    this.rData,
  });

  ReferenceState copyWith({
    RequestState? requestState,
    List<ReferenceOnListModel>? references,
    bool successVerifyClinicalRecords = false,
    String? rData,
  }) {
    return ReferenceState(
      references: references ?? this.references,
      rData: rData,
    );
  }
}
