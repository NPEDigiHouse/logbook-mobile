part of 'history_cubit.dart';

class HistoryState {
  final RequestState? requestState;
  final List<HistoryModel>? histories;
  final RequestState? requestStateIo;
  final List<HistoryModel>? historiesIo;

  HistoryState({
    this.histories,
    this.requestState,
    this.historiesIo,
    this.requestStateIo,
  });

  HistoryState copyWith({
    RequestState? requestState,
    List<HistoryModel>? histories,
    RequestState? requestStateIo,
    List<HistoryModel>? historiesIo,
  }) {
    return HistoryState(
      histories: histories ?? this.histories,
      requestState: requestState ?? RequestState.init,
      historiesIo: historiesIo ?? this.historiesIo,
      requestStateIo: requestStateIo ?? RequestState.init,
    );
  }
}
