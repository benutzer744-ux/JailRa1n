# JailRa1n 0.1

SwiftUI user-interface prototype for iPhone. Target concept: iOS 27.0.1 untethered jailbreak. **No jailbreak engine, exploit, persistence mechanism or security bypass is included.** The Jailbreak button is disabled.

## Included
- Dark/neon-green interface and 1024×1024 neon droplet AppIcon
- Current iOS version, device name, and hardware identifier (e.g. `iPhone16,1`)
- Settings page with working persistent neon-glow toggle
- Explicit unavailable engine status

## Build
This archive contains an XcodeGen project specification (`project.yml`) and all source/assets. On a Mac with Xcode and XcodeGen installed, run `xcodegen generate` in this folder, then open `JailRa1n.xcodeproj`, select your Apple development team and unique bundle identifier, and build for a connected iPhone. Alternatively import the Swift files and asset catalog into a new Xcode iOS App project.

**iPhone-only limitation:** iOS does not natively compile/sign this Xcode project. A Mac or trusted remote macOS build/signing environment is required to produce an installable IPA. Do not upload Apple ID passwords or signing certificates to unknown services.

**Compatibility:** Deployment target is iOS 17.0+ for the UI. This does not mean a jailbreak exists for those versions. The iOS 27.0.1 target label is aspirational and is not an actual compatibility check.
