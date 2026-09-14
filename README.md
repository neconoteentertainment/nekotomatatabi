# ねことまた旅（初版プロトタイプ）

仕様書.xlsx をもとに作成した Flutter ソースです。

## 実装済み
- GPSから現在地を取得
- OpenStreetMap / Overpass APIで約2.5km以内の観光地・施設候補を表示
- 訪問場所、訪問日、一言メモを端末内に保存
- 都道府県別の訪問状況表示（47都道府県マップ）
- OpenStreetMap上に訪問地点をピン表示
- 写真を複数枚、訪問記録に紐づけて保存
- カメラ上に自作スタンプを表示しながら撮影
- 撮影写真へスタンプを合成して保存
- 文字スタンプ（デフォルト「ねことまた旅」）
- 自作スタンプ4枠。端末内へコピーしてアプリ更新後も保持する設計
- 観光地1件につき1P、ご当地アイテム 5/10/20/30/40/50P
- アプリ使用方法

## 初回セットアップ
この環境には Flutter SDK が無いため、Android/iOSの生成済みネイティブ雛形までは検証できていません。
Flutter SDK が入ったPCでプロジェクトフォルダを開き、次を実行してください。

```bash
flutter create . --platforms=android,ios --org com.neconote --project-name nekotomatatabi
flutter pub get
flutter run
```

`android/app/src/main/AndroidManifest.xml` と `ios/Runner/Info.plist` は本ZIPの内容を使用してください。`flutter create` により上書きされた場合は、権限設定を本ファイルから戻してください。

## 初版で仮決めした仕様
1. データ保存先: クラウドではなく端末内（SharedPreferences + ApplicationDocumentsDirectory）
2. 周辺観光地: APIキー不要のOpenStreetMap/Overpassを利用
3. 「日本地図を塗りつぶす」: 初版は47都道府県を色分けする簡易マップ
4. ご当地アイテム: 地域区分が未定のため、まず共通6段階で実装
5. 制作者HP: `https://example.com` の仮URL。`lib/screens/home_screen.dart` のURLを本番URLへ変更してください

## 次回仕様書で決めたい点
- ご当地アイテムの「各地域」が8地方なのか47都道府県なのか
- 旅行単位（例: 2026年京都旅行）の作成・名称変更ルール
- 写真の端末外バックアップ（Firebase / iCloud / Google Drive等）の要否
- 正式な日本地図SVGのデザイン
- 観光地候補の取得元をGoogle Places等にするか（API料金・利用規約を考慮）
- 制作者HPの正式URL

## 注意
OpenStreetMap / Overpass / Nominatim は外部サービスです。公開規模が大きくなる場合は、利用規約とアクセス頻度を再確認し、必要に応じて正式な観光地APIへ切り替えてください。


## Windowsで `No Windows desktop project configured` が出る場合

初版の `setup_windows.bat` に Windows プラットフォーム指定が抜けていました。修正版では対応済みです。

1. `setup_windows.bat` を実行
2. 完了後にコマンドプロンプトでプロジェクトフォルダへ移動
3. `flutter run -d windows` を実行

手動で直す場合は、プロジェクトフォルダで以下を実行してください。

```bat
flutter config --enable-windows-desktop
flutter create . --platforms=windows --org com.neconote --project-name nekotomatatabi
flutter pub get
flutter run -d windows
```

Windowsで標準 `camera` APIを利用できるよう `camera_windows` も依存関係に追加しています。
