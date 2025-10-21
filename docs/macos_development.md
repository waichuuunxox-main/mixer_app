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

## Widget sync verification & local fonts

### Verify Flutter → Native write (App Group)

After enabling App Group in Xcode and running the app on macOS, trigger the in-app "Sync" (Widget Preview or Home Page). Then verify:

```bash
ls -la ~/Library/"Group Containers"/group.com.waichuuun.mixzer
cat ~/Library/"Group Containers"/group.com.waichuuun.mixzer/mixzer_widget_summary.json
```

If the JSON exists and contains a `nextMatch` and `timestamp`, the native `writeSummary` handler successfully wrote shared data for WidgetKit.

### Embed local fonts (NotoSans example)

This repo includes NotoSans Regular and Bold in `assets/fonts/` and registers them in `pubspec.yaml` as `NotoSans`. The app's `ThemeData` has been updated to use `fontFamily: 'NotoSans'` so the app no longer relies on runtime font downloads.

To update fonts or add more weights:

1. Add the TTF files into `assets/fonts/`.
2. Add entries under `flutter:
  fonts:` in `pubspec.yaml`.
3. Run `flutter pub get` and rebuild.



## 自動化 widget 工作流程（範例腳本）

本專案內建一組簡單腳本，可幫助你把 repo 中的 Widget 範例複製到你的 Xcode widget target，並自動替換 App Group identifier。檔案位置：`scripts/`。

- `scripts/package_widget.sh`：把 `ios/WidgetExample` 打包為 `artifacts/widget_example.zip`。
- `scripts/install_widget_to_xcode.sh`：將 `ios/WidgetExample` 的檔案複製到指定的 Xcode widget target 資料夾，並替換 Swift 檔案內的 App Group placeholder（支援 `group.com.example.mixzer` 或 `APP_GROUP_PLACEHOLDER`）。

範例使用步驟：

1. 打包（可選）：

```bash
chmod +x scripts/package_widget.sh
./scripts/package_widget.sh
```

2. 安裝到你的 Xcode widget target（會替換 App Group）：

```bash
chmod +x scripts/install_widget_to_xcode.sh
./scripts/install_widget_to_xcode.sh group.com.yourcompany.mixzer /path/to/YourXcodeProject/Widgets/MixzerWidget --overwrite
```

3. 開啟 Xcode：
  - 在主應用與 widget 目標的 Signing & Capabilities 中啟用相同的 App Group（例如 `group.com.yourcompany.mixzer`）。
  - 設定 widget target 的 bundle identifier 與簽名 Team。

4. 在 Xcode 內 build 一次以讓變更生效，然後在 macOS 上測試 widget（或使用 Widget Debugging 工具）。

注意：腳本只會複製檔案與替換檔案內的 App Group 字串；Xcode 專案內的 target 設定（如 bundle id、簽名）需手動在 Xcode 內完成。

## 參考變更摘要

變更摘要已加入 `docs/changes/auto_widget_workflow.md`，說明本次自動化腳本與測試的新增內容。

