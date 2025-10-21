# macOS 開發指南

本檔案說明如何在 macOS 上建立、執行與除錯 Mixzer 應用程式。假設你已經安裝了 Flutter。若要在 macOS 建置/執行，必須使用一台安裝 Xcode 的 Mac。

## 前置條件

- macOS 11+（或依照 Flutter 官方對 macOS 的支援版本）
- 安裝 Xcode（從 App Store）與 Xcode Command Line Tools
- Flutter SDK（stable channel 建議）
- Xcode 路徑設定：

  sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

## 設定步驟

1. 更新 Flutter 與 macOS 支援

```bash
flutter doctor
flutter channel stable
flutter upgrade
```

2. 驗證 Flutter 支援 macOS

```bash
flutter config --enable-macos-desktop
flutter doctor
```

3. 開啟 Xcode 並同意授權

打開 Xcode 一次並接受 license。若需要，登入你的 Apple Developer 帳號以執行簽名相關操作。

4. 簽名與團隊設定

- 若要建立可發佈的 macOS 應用，你需要在 Xcode 的 Runner target 以及任何 extension targets（若有）設定簽名 (Signing & Capabilities) 與 Team。對於本地開發，使用你的 Apple ID 即可。

5. 執行應用（開發）

建議使用專案中提供的腳本：

```bash
chmod +x scripts/run_macos.sh
./scripts/run_macos.sh
```

或直接使用 flutter 命令：

```bash
flutter pub get
flutter run -d macos
```

## 常見錯誤與排查

- xcrun / xcodebuild not found: 表示 Xcode 或 command line tools 未安裝或未正確選取；請安裝 Xcode 並執行 `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`。
- code signing 問題：在 Xcode 的 Runner target 中設定 Team，或使用自動簽名；若要建立 release，記得在 Xcode 設定適當的 provisioning profile。
- Flutter plugin 原生相依失敗：確保執行 `flutter pub get` 並開啟 `macos/Runner.xcworkspace` 在 Xcode 中進行一次 build 以取得原生依賴。

## Widget (macOS) 注意事項

WidgetKit 在 macOS 與 iOS 的行為類似；如果你要在 macOS 上使用 Widget（在 Big Sur+），請注意：

- 需要在 Xcode 中為 Widget target 啟用 App Group（與主應用共用資料）
- App Group identifier 必須在主應用與 Widget target 都啟用
- 本 repo 提供 `artifacts/widget_example.zip` 與 `ios/WidgetExample` 範本，可作為複製到你的 Widget target 的起點

## 進階：建立簽名的 Release 包

1. 在 Xcode 選擇 Runner target，選擇 Release scheme
2. Archive 應用（Product → Archive），並使用 Organizer 導出簽名好的 .app 或安裝包

## 補充資源

- Flutter macOS docs: https://docs.flutter.dev/desktop
- Apple Developer: https://developer.apple.com

---

若需要，我可以把常見的 Debug 指令範例與一個 `scripts/build_macos_release.sh` 腳本加入 repo（會包含 Xcode archive 與導出步驟的提示）。
