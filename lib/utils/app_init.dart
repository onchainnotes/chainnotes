import 'package:chain_notes/common/constants/app_constants.dart';
import 'package:freerasp/freerasp.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';

class AppInit {
  static Future<void> init() async {

    if (kDebugMode) {
      return;
    }

    // create a configuration for freeRASP
    final config = TalsecConfig(
      /// For Android
      androidConfig: AndroidConfig(
        packageName: 'com.ywy.chainnotes.chain_notes',
        signingCertHashes: [
          '{sensitive information}',
        ], // Replace with your release (!) signing certificate hash(es)
        supportedStores: ['com.android.vending'],
      ),

      iosConfig: IOSConfig(
        bundleIds: const ['com.ywy.chainnotes'],
        teamId: '{sensitive information}',
      ),
      watcherMail: AppConstants.securityWatcher,
      // for Security Reports, Talsec
      // Portal, Updates

      isProd: true,

    );

    await Talsec.instance.start(config);

    final callback = ThreatCallback(
      onAppIntegrity: () => print("安全检测：应用完整性异常 (App integrity)"),
      onObfuscationIssues: () => print("安全检测：混淆问题 (Obfuscation issues)"),
      onDebug: () => print("安全检测：检测到调试 (Debugging)"),
      onDeviceBinding: () => print("安全检测：设备绑定异常 (Device binding)"),
      onDeviceID: () => print("安全检测：设备 ID 异常 (Device ID)"),
      onHooks: () async {
        print("安全检测：检测到 Hook (Hooks)");
        await Sentry.captureMessage("Hook detected");
        exit(0);
      },
      onPasscode: () => print("安全检测：未设置锁屏密码 (Passcode not set)"),
      onPrivilegedAccess: () => print("安全检测：检测到特权访问 (Privileged access)"),
      onSecureHardwareNotAvailable: () =>
          print("安全检测：安全硬件不可用 (Secure hardware not available)"),
      onSimulator: () => print("安全检测：检测到模拟器 (Simulator)"),
      onSystemVPN: () => print("安全检测：检测到系统 VPN (System VPN)"),
      onDevMode: () => print("安全检测：检测到开发者模式 (Developer mode)"),
      onADBEnabled: () => print("安全检测：USB 调试已开启 (USB debugging enabled)"),
      onUnofficialStore: () => print("安全检测：非官方应用商店来源 (Unofficial store)"),
      onScreenshot: () => print("安全检测：检测到截屏 (Screenshot)"),
      onScreenRecording: () => print("安全检测：检测到录屏 (Screen recording)"),
      onMultiInstance: () => print("安全检测：检测到多开 (Multi instance)"),
      onUnsecureWiFi: () => print("安全检测：不安全 Wi‑Fi (Unsecure wifi)"),
      onLocationSpoofing: () => print("安全检测：定位欺骗 (Location spoofing)"),
      onTimeSpoofing: () => print("安全检测：时间欺骗 (Time spoofing)"),
      onAutomation: () => print("安全检测：检测到自动化 (Automation detected)"),
      onMalware: (suspiciousApps) =>
          print("安全检测：疑似恶意应用 $suspiciousApps (Suspicious apps)"),
    );

    // Attaching listener
    Talsec.instance.attachListener(callback);
  }
}
