import Flutter
import ObjectiveC
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    FirebaseLaunchGuard.install()
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}

/// Firebase iOS 在插件注册时就会读取 GoogleService-Info.plist 并校验 API Key。
/// Key 不是 39 位、且以 A 开头的字母数字时，会抛出未捕获的 NSException，进程直接退出。
enum FirebaseLaunchGuard {
  private static let expectedLength = 39
  private static var installed = false

  static func install() {
    if installed || bundledApiKeyIsUsable() { return }
    guard let optionsClass = NSClassFromString("FIROptions") else { return }
    guard let meta: AnyClass = object_getClass(optionsClass) else { return }
    let selector = NSSelectorFromString("defaultOptions")
    guard let method = class_getInstanceMethod(meta, selector) else { return }
    let block: @convention(block) (AnyObject) -> AnyObject? = { _ in nil }
    method_setImplementation(method, imp_implementationWithBlock(block))
    installed = true
  }

  private static func bundledApiKeyIsUsable() -> Bool {
    guard
      let url = Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist"),
      let dict = NSDictionary(contentsOf: url),
      let key = dict["API_KEY"] as? String
    else {
      return false
    }
    return isUsableApiKey(key)
  }

  static func isUsableApiKey(_ key: String?) -> Bool {
    guard let key, key.count == expectedLength, key.hasPrefix("A") else { return false }
    return key.unicodeScalars.allSatisfy { scalar in
      CharacterSet.alphanumerics.contains(scalar) || scalar == "-" || scalar == "_"
    }
  }
}
