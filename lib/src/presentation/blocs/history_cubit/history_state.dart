part of 'history_cubit.dart';

class HistoryState {
  final RequestState? requestState;
  final List<HistoryModel>? histories;

  HistoryState({
    this.histories,
    this.requestState,
  });

  HistoryState copyWith({
    RequestState? requestState,
    List<HistoryModel>? histories,
  }) {
    return HistoryState(
      histories: histories ?? this.histories,
      requestState: requestState ?? RequestState.init,
    );
  }
}
