part of 'notification_cubit.dart';

enum ActivityType {
  sgl,
  cst,
  ceuSgl,
  ceuCst,
  osce,
  cbt,
  clinicalRecord,
  scientificSession,
  personalBehavior,
  problemConsultation,
  skills,
  cases,
  finalScore,
  weeklyAssessment,
  dailyActivity,
  miniCex,
  scientificAssignment,
  checkIn,
  checkOut,
  selfReflection,
}

class NotificationState {
  final List<NotificationModel>? notification;
  final RequestState fetchState;
  final bool isReadNotification;

  NotificationState({
    this.notification,
    this.fetchState = RequestState.init,
    this.isReadNotification = false,
  });

  NotificationState copyWith({
    List<NotificationModel>? notification,
    RequestState? fetchState,
    bool isReadNotification = false,
  }) {
    return NotificationState(
      isReadNotification: isReadNotification,
      notification: notification ?? this.notification,
      fetchState: fetchState ?? this.fetchState,
    );
  }

  int get unreadNotification => notification == null
      ? 0
      : notification!.where((element) => element.isSeen == false).length;
}
