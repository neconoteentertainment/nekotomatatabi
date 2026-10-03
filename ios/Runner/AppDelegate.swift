import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let appGroupId = "group.com.neconote.nekotomatatabi"
  private let pendingFavoritesKey = "pending_favorite_sites_v1"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let shareInboxChannel = FlutterMethodChannel(
      name: "com.neconote.nekotomatatabi/share_inbox",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    shareInboxChannel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "takePendingFavoriteSites" else {
        result(FlutterMethodNotImplemented)
        return
      }
      result(self?.takePendingFavoriteSites() ?? [])
    }
  }

  private func takePendingFavoriteSites() -> [[String: Any]] {
    guard let defaults = UserDefaults(suiteName: appGroupId),
          let encoded = defaults.string(forKey: pendingFavoritesKey),
          let data = encoded.data(using: .utf8),
          let rows = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
      return []
    }

    // Flutterへ渡せた項目は一度だけ取り込む。
    defaults.removeObject(forKey: pendingFavoritesKey)
    return rows
  }
}
