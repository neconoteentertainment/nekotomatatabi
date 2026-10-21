# AdMob本番ID設定版 0.26.5+41（2026年10月21日）

## 変更

- ユーザー添付の最新nekotomatatabi.zipをベースに変更。
- iOS App ID: `ca-app-pub-4121724126236374~5720264297`
- iOS Banner ID: `ca-app-pub-4121724126236374/9003621928`
- Android App ID: `ca-app-pub-4121724126236374~8369197101`
- Android Banner ID: `ca-app-pub-4121724126236374/6239139049`
- Releaseでは本番ユニット、Debug / ProfileではGoogle公式テストユニットを使用。
- `--dart-define=USE_TEST_ADS=true` で配布テストのReleaseにもテストユニットを使用。
- Macセットアップ時のID書き戻しも本番アプリIDに更新。
- アプリ版数は0.26.5+41。撮影・共有・記録・全国観光地データと依存パッケージは変更なし。

## 検証

- Flutter 3.47.7 / Dart 3.13.5で広告設定の8テストが成功。通常とUSE_TEST_ADS=trueの両条件で実施し、合計16件成功。
- 広告設定・サービス・バナー・新テストの静的解析にエラーなし。バナーに従来からあるadaptive size APIの非推奨infoが1件あり、今回レイアウトは変更していません。
- AndroidManifest.xml / iOS Info.plist の本番App ID、setup_mac.sh の構文・本番App ID維持を確認。
- テスト環境ではFlutter SDK固定パッケージ4件の解決バージョンが変わりますが、納品ZIPのpubspec.lockはアップロードされた元のものをそのまま保持。
- 署名付きIPA / AABのビルド・実機の広告配信はこの環境では未確認。AdMob側の審査や設定を完了したことを示すものではありません。
- Android Releaseのデバッグ署名は元のままです。公開前に配布用署名を設定する必要があります。

## 同梱から除外した生成物

- Android local.properties、iOS / Windows ephemeral、.flutter-plugins-dependencies、iOS Generated.xcconfig / flutter_export_environment.sh、IDEの.idea / *.iml。
- いずれも端末固有・再生成可能な内容です。既存のGitフォルダへの反映時はご自身の.git・署名鍵・署名設定を保持してください。
- 起動・配布コマンドはREADME.md先頭を参照。
