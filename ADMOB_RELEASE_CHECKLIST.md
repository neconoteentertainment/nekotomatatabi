# AdMob 本番公開前チェックリスト

この版は誤クリック・誤課金を避けるため、Google公式テスト広告だけを表示します。
テスト広告が正常に出ることを確認してから、次の順で本番用へ切り替えてください。

## 1. AdMob側で作成

- AdMobへiOSアプリとAndroidアプリを別々に登録する。
- 各アプリに「バナー」広告ユニットを1つ作る。
- 「プライバシーとメッセージ」で、対象地域に必要な同意メッセージを公開する。
- App Store・Google Playの公開URLが決まったらAdMobへ登録する。

## 2. アプリIDを差し替える

- iOS: `ios/Runner/Info.plist` の `GADApplicationIdentifier`
- Android: `android/app/src/main/AndroidManifest.xml` の
  `com.google.android.gms.ads.APPLICATION_ID`
- Mac初回セットアップ用: `setup_mac.sh` 内のテスト用アプリID 2か所

アプリIDは `ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy` のように、区切りが
チルダ（`~`）です。

## 3. バナー広告ユニットIDを差し替える

`lib/services/ad_service.dart` の次の2項目を置き換えます。

- `_androidBannerTestId`
- `_iosBannerTestId`

広告ユニットIDは `ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyy` のように、区切りが
スラッシュ（`/`）です。アプリIDと取り違えないでください。

## 4. 実機で最終確認

- ID差し替え中の確認では、自分の端末をAdMobのテストデバイスに登録する。
- 自分で本番広告を繰り返しクリックしない。
- 同意を拒否した場合、許可した場合、通信がない場合をそれぞれ確認する。
- 縦画面でバナーが本文やボタンに重ならないことを全画面で確認する。
- Windows版では広告欄が表示されないことを確認する。

## 5. ストア申請前

- プライバシーポリシーに広告SDK、取得情報、同意変更方法を記載する。
- App Storeの「Appのプライバシー」とGoogle Playの「データ セーフティ」を
  実際の広告設定に合わせて回答する。
- AdMobのサイト運営者情報と `app-ads.txt` を準備する。
- テストIDがプロジェクト内に残っていないことを検索して確認する。

```bash
grep -R "ca-app-pub-3940256099942544" lib ios android setup_mac.sh
```

検索結果が0件になってからリリースビルドを作成してください。
