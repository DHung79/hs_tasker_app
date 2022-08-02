import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/notification/notification.dart';
import '../../main.dart';
import '../../routes/route_names.dart';
import 'fcm_model.dart';

Future<void> _showNotification({String? title, String? body}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const IOSNotificationDetails iosPlatformChannelSpecifics =
      IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  NotificationDetails platformChannelSpecifics = const NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iosPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    title ?? '',
    body ?? '',
    platformChannelSpecifics,
    payload: selectedNotificationPayload,
  );
}

void requestPermissionsLocal() {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

void registerNotification({
  PushNotification? notificationInfo,
  required Function(String?) getFcmToken,
}) async {
  await Firebase.initializeApp();
  FirebaseMessaging? _messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    logDebug('User granted permission');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // logDebug('onMessage: ${message.data}');
      if (message.data['body'] != null) {
        // if (notiCountKey.currentState != null) {
        //   notiCountKey.currentState!.notificationBloc
        //       .add(NotificationUnreadTotal());
        // }

        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'].toString(),
          dataBody: message.data['body'].toString(),
        );

        notificationInfo = notification;
        // _totalNotifications++;

        if (notificationInfo != null) {
          // For displaying the notification as a n overlay
          /* showSimpleNotification(
            Text(_notificationInfo.title),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo.body),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          ); */
          if (message.notification?.title != null) {
            _showNotification(
              title: notificationInfo!.title,
              body: notificationInfo!.body,
            );
          }
        }
      }
    });
  } else {
    logDebug('User declined or has not accepted permission');
  }

  //Get FCM token
  _messaging.getToken().then(
    (fcmToken) {
      logDebug('fcmToken: $fcmToken');
      getFcmToken(fcmToken);
      currentFcmToken = fcmToken;
      NotificationRepository()
          .updateFcmToken(body: {'fcm_token': '$fcmToken'})
          .then((value) => logDebug(
              'Call updateFcmToken to server ${value ? 'Ok' : 'Fail'}'))
          .catchError((e) => logDebug('Call updateFcmToken Error: $e'));
    },
  ).catchError((dynamic err) {
    logDebug('Has some errors on get fcmToken: $err');
  });
}

// For handling notification when the app is in terminated state
void checkForInitialMessage(
    {required Function(PushNotification) getNotification}) async {
  await Firebase.initializeApp();
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    PushNotification notification = PushNotification(
      title: initialMessage.notification?.title,
      body: initialMessage.notification?.body,
      dataTitle: initialMessage.data['title'].toString(),
      dataBody: initialMessage.data['body'].toString(),
    );
    getNotification(notification);
    // setState(() {
    //   _notificationInfo = notification;
    //   // _totalNotifications++;
    // });
  }
}

initLocalPushNotification() async {
  NotificationModel? noti;
  NotificationType? notiModel;
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    notiModel = NotificationType.fromJson(
      jsonDecode(message.data['type_notification']),
    );
    noti = NotificationModel.fromJson(message.data);
    NotificationBloc().getTotalUnread().then((value) {
      notiBadges = value.totalUnreadNoti;
    });
  });
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('launcher_icon');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification:
              (int id, String? title, String? body, String? payload) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
                id: id, title: title, body: body, payload: payload));
          });

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      logDebug('notification payload: $payload');
      if (noti != null && notiModel != null && notiModel!.status != null) {
        if (notiModel!.status == 3) {
          navigateTo(jobDetailRoute + '/${noti!.taskId}');
        } else if (notiModel!.status! == 4) {
          navigateTo(taskHistoryRoute + '/${noti!.taskId}');
        }
      } else {
        navigateTo(notificationRoute);
      }
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await NotificationRepository().notiUnreadTotal<UnreadTotalModel>().then(
  //   (value) {
  //     newNoti = value.model!.total;
  //     FlutterAppBadger.updateBadgeCount(newNoti);
  //     if (notiKey.currentState != null) {
  //       notiKey.currentState!.refreshData();
  //     }
  //   },
  // );

  logDebug("Handling a background message: ${message.messageId}");
}
