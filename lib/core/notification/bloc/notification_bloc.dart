import 'package:bloc/bloc.dart';
import '../notification.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitialState()) {
    final NotificationRepository notificationService = NotificationRepository();
    on<NotificationFetchEvent>((event, emit) async {
      emit(NotificationWaitingState());
      try {
        final res = await notificationService
            .fetchAllData<NotificationListModel>(params: event.params!);
        // ignore: unnecessary_null_comparison
        if (res != null) {
          emit(NotificationFetchDoneState(res));
        } else {
          emit(const NotificationFetchFailState(message: 'Lỗi không xác định'));
        }
      } on Error catch (e) {
        emit(NotificationFetchFailState(
          message: e.toString(),
        ));
      }
    });
    on<ReadNotification>((event, emit) async {
      emit(NotificationWaitingState());
      try {
        final res = await notificationService.readNoti<NotificationModel>(
            params: event.params);
        // ignore: unnecessary_null_comparison
        if (res != null) {
          emit(ReadNotificationDoneState(res));
        } else {
          emit(const NotificationFetchFailState(message: 'Lỗi không xác định'));
        }
      } on Error catch (e) {
        emit(NotificationFetchFailState(
          message: e.toString(),
        ));
      }
    });
    on<ReadAllNotification>((event, emit) async {
      emit(NotificationWaitingState());
      try {
        final res = await notificationService.notiReadAll<UnreadTotalModel>();
        // ignore: unnecessary_null_comparison
        if (res != null) {
          emit(NotificationReadAllDoneState(res));
        } else {
          emit(const NotificationFetchFailState(message: 'Lỗi không xác định'));
        }
      } on Error catch (e) {
        emit(NotificationFetchFailState(
          message: e.toString(),
        ));
      }
    });
    on<NotificationUnreadTotal>((event, emit) async {
      emit(NotificationWaitingState());
      try {
        final res =
            await notificationService.notiUnreadTotal<UnreadTotalModel>();
        // ignore: unnecessary_null_comparison
        if (res != null) {
          emit(NotificationUnreadTotalDoneState(res, event.notiId));
        } else {
          emit(const NotificationFetchFailState(message: 'Lỗi không xác định'));
        }
      } on Error catch (e) {
        emit(NotificationFetchFailState(
          message: e.toString(),
        ));
      }
    });
    on<GetNewNotificationEvent>((event, emit) async {
      emit(NotificationWaitingState());
      try {
        final res = await notificationService
            .fetchAllData<NotificationListModel>(params: event.params!);
        // ignore: unnecessary_null_comparison
        if (res != null) {
          emit(GetNewNotificationDoneState(res));
        } else {
          emit(const NotificationFetchFailState(message: 'Lỗi không xác định'));
        }
      } on Error catch (e) {
        emit(NotificationFetchFailState(
          message: e.toString(),
        ));
      }
    });
  }
}
