import 'package:data/datasources/remote_datasources/notification_datasource.dart';
import 'package:data/models/notification/notification_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationDataSource dataSource;
  NotificationCubit({required this.dataSource}) : super(NotificationState()) {
    getNotifications(page: 1);
  }

  Future<void> readNotification({required String id}) async {
    try {
      await dataSource.readNotification(id: id);
      emit(state.copyWith(isReadNotification: true));
    } catch (e) {
      emit(
        state.copyWith(
          fetchState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getNotifications({
    String? query,
    required int page,
    String? unitId,
    bool? isUnread,
    String? activityType,
    bool withLoading = true,
  }) async {
    try {
      if (withLoading) {
        emit(state.copyWith(
          fetchState: RequestState.loading,
        ));
      }

      final result = await dataSource.getNotifications(
          unitId: unitId,
          page: page,
          isUnread: isUnread,
          query: query,
          activityType: activityType);
      result.fold(
          (l) => emit(state.copyWith(fetchState: RequestState.error)),
          (r) => emit(state.copyWith(
                notification: r,
                fetchState: RequestState.data,
                isReadNotification: false,
              )));
    } catch (e) {
      emit(
        state.copyWith(
          fetchState: RequestState.error,
        ),
      );
    }
  }
}
