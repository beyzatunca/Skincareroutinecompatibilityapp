# Skincare Routine Compatibility App

Native **iOS uygulaması** (SwiftUI). Bu proje Figma’dan export edilen web kodu ile ilişkili değildir; bağımsız bir iOS projesidir.

## iOS uygulamasını çalıştırma

1. `ios/Skincareroutinecompatibilityapp.xcodeproj` dosyasını Xcode ile açın.
2. Bir iOS Simulator seçin (örn. iPhone 16 Plus).
3. **Product → Run** (⌘R) ile derleyip simülatörde çalıştırın.

### Komut satırından

```bash
cd ios
xcodebuild -scheme Skincareroutinecompatibilityapp \
  -destination 'platform=iOS Simulator,name=iPhone 16 Plus,OS=18.5' \
  build
```

Ardından derlenen `.app` dosyasını simülatöre yükleyip `com.skincareroutine.app` bundle identifier ile başlatabilirsiniz.

## Proje yapısı

- **`ios/`** – SwiftUI iOS uygulaması (ana proje)
- Kök dizindeki `package.json`, `src/`, `index.html` vb. bu iOS uygulaması ile alakalı değildir.
