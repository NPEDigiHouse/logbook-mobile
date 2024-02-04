part of 'notification_cubit.dart';

class NotificationState {
  final List<NotificationModel>? notification;
  final RequestState fetchState;

  NotificationState({
    this.notification,
    this.fetchState = RequestState.init,
  });

  NotificationState copyWith({
    List<NotificationModel>? notification,
    RequestState? fetchState,
  }) {
    return NotificationState(
      notification: notification ?? this.notification,
      fetchState: fetchState ?? this.fetchState,
    );
  }

  int get unreadNotification => notification == null
      ? 0
      : notification!.where((element) => element.isSeen == false).length;
}
