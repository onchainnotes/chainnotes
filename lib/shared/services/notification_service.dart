import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:chain_notes/shared/config/env_config.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flnp =
      FlutterLocalNotificationsPlugin();

  static bool _backgroundHandlerRegistered = false;

  static Future<String?> initialize() async {
    if (!EnvConfig.hasUsableFirebaseApiKey) {
      debugPrint('通知服务已跳过：Firebase API Key 格式不可用');
      return null;
    }
    try {
      await Firebase.initializeApp(
        options: EnvConfig.currentPlatform,
        name: EnvConfig.firebaseName,
      );
      await _initLocalNotifications();
      String? payload = await _handleColdStartFromNotification();
      await _initFirebaseMessaging();
      return payload;
    } catch (e) {
      debugPrint('通知服务初始化失败: $e');
      return null;
    }
  }

  static Future<String?> _handleColdStartFromNotification() async {
    String? payload;
    final initialMsg = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMsg != null) {
      payload = initialMsg.data['message_json'];
      if (payload != null) return payload;
    }
    final launchDetails = await flnp.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      payload = launchDetails!.notificationResponse?.payload;
      if (payload != null) return payload;
    }
    return payload;
  }

  static Future<void> _initFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('用户已经授权');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('用户授予临时权限');
      return;
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('用户已经拒绝授权');
      return;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      debugPrint('用户还未授权');
      return;
    } else {
      return;
    }
    initNotificationAfterPermission();
  }

  static Future<void> initNotificationAfterPermission() async {
    try {
      final String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _postPushToken(pushToken: token);
      }
    } catch (e) {

      debugPrint('FirebaseMessaging getToken 失败（可能为模拟器或无 GMS 环境）: $e');
    }

    try {
      FirebaseMessaging.instance.onTokenRefresh.listen((t) {
        _postPushToken(pushToken: t);
      });
      FirebaseMessaging.onMessage.listen(_onForegroundSystemNotification);
      FirebaseMessaging.onMessageOpenedApp.listen((msg) {
        String? payload = msg.data['message_json'];
        if (payload != null) gotoMsgDetails(payload);
      });
      if (!_backgroundHandlerRegistered) {
        FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
        _backgroundHandlerRegistered = true;
      }
    } catch (e) {
      debugPrint('Firebase Messaging 监听注册失败: $e');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    if (!EnvConfig.hasUsableFirebaseApiKey) return;
    await Firebase.initializeApp(
      options: EnvConfig.currentPlatform,
      name: EnvConfig.firebaseName,
    );
    final payload = message.data['message_json'];
    if (payload != null) {
      await _showLocalNotificationWrapper(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: payload,
      );
    }
  }

  static Future<void> _onForegroundSystemNotification(RemoteMessage msg) async {
    final payload = msg.data['message_json'];
    await _showLocalNotificationWrapper(
      title: msg.notification?.title ?? '',
      body: msg.notification?.body ?? '',
      payload: payload,
    );
  }

  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final DarwinInitializationSettings ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    try {
      await flnp.initialize(
        settings: InitializationSettings(android: android, iOS: ios),
        onDidReceiveNotificationResponse: (res) {
          final payload = res.payload;
          if (payload != null) gotoMsgDetails(payload);
        },
        onDidReceiveBackgroundNotificationResponse:
            _onLocalNotificationClickBackground,
      );
    } catch (error) {
      debugPrint('flutterLocalNotificationsPlugin.initialize error: $error');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _onLocalNotificationClickBackground(
    NotificationResponse response,
  ) async {
    final payload = response.payload;
    if (payload != null) gotoMsgDetails(payload);
  }

  static Future<void> _showLocalNotificationWrapper({
    required String title,
    required String body,
    required String? payload,
  }) async {
    if (payload == null) return;
    final p = jsonDecode(payload);
    p['source'] = 'local';
    final encoded = jsonEncode(p);
    await showLocalNotification(title: title, body: body, payload: encoded);
  }

  static Future<void> showLocalNotification({
    required String title,
    required String body,
    required String payload,
    String? messageId,
  }) async {
    final android = AndroidNotificationDetails(
      'local_message',
      'Messages',
      importance: Importance.max,
      priority: Priority.high,
    );
    final ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    try {
      int timeNow = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await flnp.show(
        id: int.tryParse(messageId ?? '$timeNow') ?? timeNow,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(android: android, iOS: ios),
        payload: payload,
      );
    } catch (e) {
      debugPrint('local通知出错：$e');
    }
  }

  static void gotoMsgDetails(String payload) {
    try {
      jsonDecode(payload);

    } catch (e) {
      debugPrint('跳转消息异常：$e');
    }
  }

  static Future<void> _postPushToken({required String pushToken}) async {
    try {

    } catch (e) {
      debugPrint('$e');
    }
  }
}
