# sip_sales

A new Flutter project.

## Update Notes
What should developers do whenever they pull new changes

**v1.2.4** — Run `flutter pub get` to pull the new `upgrader` and `flutter_secure_storage` dependencies.
- Create `android/key.properties` locally (gitignored) with your keystore credentials — see the signing config in `build.gradle` for required keys.
- Breaking: `CoordinatorDashboardEmpty` is a new BLoC state — any screen listening to `ShopCoordinatorBloc` must handle this state.
- Breaking: `FaceRecognitionLocalDatasource` and `FaceRecognitionRegulaDatasource` constructors now take `FlutterSecureStorage storage` instead of `SharedPreferences prefs` — update any manual instantiation.

## Version History

### 🚀 v1.2.4 - "Face Recognition & Security Hardening"

**What's New:**

🔒 **Security & Authentication**

- **Face Recognition Login** — Full biometric face enrollment and verification flow integrated into the login and attendance pipeline using a dual-method approach (TFLite embeddings + Regula SDK matching)
- **Real-time Face Capture** — Live camera preview with real-time face detection during both enrollment and verification; oval position guide overlays the camera feed for better alignment accuracy
- **Dedicated Blocked Screen** — New full-screen UI shown when login is blocked due to emulator detection, rooted/jailbroken device, or account being opened on another device
- **Device Binding** — `isLoginAllowed` check added: if the account is already active on another device, the session is blocked and the user is auto-logged out with a clear message
- **Encrypted Biometric Storage** — Face embeddings and reference images migrated from plain `SharedPreferences` to `FlutterSecureStorage` with `encryptedSharedPreferences` on Android and Keychain on iOS — biometric data is now stored encrypted at rest
- **Keystore Credentials Secured** — Removed hardcoded signing passwords from `build.gradle`; credentials are now loaded from `key.properties` which is gitignored and never committed to source control
- **Internet Connectivity Check Restored** — Login now shows a clear `"Tidak ada koneksi internet."` message before attempting the API call when there is no network, instead of throwing a cryptic HTTP exception

🐛 **Bug Fixes**

- Fixed face detection on profile photo upload failing entirely — detection pipeline refactored so ML Kit runs correctly on the captured image before enrollment proceeds
- Fixed face enrollment pipeline not completing — Regula SDK initialization sequence and verification flow corrected end-to-end
- Fixed a critical login bug where users could be auto-logged in with a previously valid account after logging out — credentials are now only saved to secure storage after the API confirms a successful login
- Fixed logout not fully clearing credentials on Android < 10 — `clearAllData()` now correctly wipes both `FlutterSecureStorage` and `SharedPreferences`
- Fixed incorrect HTTP status code check in the **attendance** API handler (`<= 200` → `>= 200 && < 300`) — previously only codes 100–200 were treated as success; codes 201–299 were incorrectly rejected
- Fixed incorrect HTTP status code check in the **login** API handler (`<= 200` → `== 200`)
- Fixed a crash (`RangeError`) when the login API returned an empty or null `Data` array — null and length guards added before accessing `Data[0]`
- Fixed `FlutterSecureStorage` being uninitialized before `initStorageConfig` was called

✨ **New Features**

- **Force Update**: Integrated `upgrader` package — users are now prompted to update from the Play Store / App Store when a newer version is available; the dialog is non-dismissible
- **Shop Coordinator — Empty State**: Added `CoordinatorDashboardEmpty` BLoC state to properly distinguish between API errors and valid responses with no data (`nodata`), enabling a dedicated empty-state UI

🔧 **Improvements**

- Release APK now has `minifyEnabled` and `shrinkResources` turned on — smaller download size and obfuscated code for production builds
- Removed iOS `BYPASS_PERMISSION_LOCATION_ALWAYS` preprocessor flag that was circumventing the standard iOS location permission model
- `toTitleCase()` formatter now forces words matching the `SpecialCharacter.ltdCompany` list (e.g. `SIP`, `BASRA`, `RSSM`) to uppercase instead of title case
- Shop Coordinator BLoC now explicitly handles all four API response statuses (`success`, `nodata`, `fail`, unknown)
- Simplified `fetchCoordinatorDashboard` response parsing — merged three identical return branches into one
- Removed two dead screen files (`head_new_acts`, `head_store_screen`) that were never wired to navigation

### 🚀 v1.2.3 - "Display & Reporting Update"

**What's New:**

📱 **Device Compatibility & UX**

- Fixed display issues on new Android devices
- Press back twice to exit the app for a smoother navigation experience

📊 **Reporting & Store Management**

- New report features for store managers
- Better image quality with full-screen viewing support
- Added new parameters and widgets for each head store activity
- Enlarged head store activity images for better visibility

🐛 **Bug Fixes**

- Fixed head store activities display (confused between activity 03 and 04)
- Visit market insertion bug fixed
- Image preview background color removed
- Fixed refresh and date filter bug in home page

### 🚀 v1.2.1 - "Head Store Activity Overhaul"

**What's New:**

📝 **New Head Store Report System**

- Completely new input method for Head Store report insertion
- Morning Briefing UI with advanced configuration
- New screens for Daily Report data insertion
- Added Visit Market, Recruitment, and Interview screens for Head Store
- Head Store activities model restructured for better data handling
- Redesigned Head Store activity details UI

🔧 **System Improvements**

- Face detector added for profile image upload
- Internet connection check
- API data submission for leasing and salesman data
- Master data added to report tables
- New API endpoints and formatter for special characters

🐛 **Bug Fixes**

- Fixed `flutter_secure_storage` bug on Android 8 devices
- Fixed storage management for older Android OS versions
- Briefing creation, display, and validation fixes
- Head Store activities validator fixed

### 🚀 v1.2.0 - "Enhanced Access Control & Authentication"

**What's New:**

🔑 **New Access Rights Level**

- Introduced Shop Coordinator role as a new access level
- Expanded system access from 2 to 3 distinct user roles:
  - Sales
  - Shop Coordinator (New!)
  - Head Store
- Improved permission management for better role-based access control
- Enhanced security with more granular access rights across the application

🔒 **App Process Improvements**

- Completely refactored app flow for better maintainability and security
- Streamlined authentication state management
- Improved error handling and user feedback during login
- Optimized token management and session handling
- Added support for the new Shop Coordinator role in the authentication flow

### 🚀 v1.1.12 - "Sales Power Unleashed!"

**What's New:**

✨ **Brand New Sales Dashboard**

- Sales team, rejoice! Your dedicated command center is here
- Track performance metrics and key sales indicators at a glance
- Quick access to essential sales tools and reports

🎨 **Fresh New Look**

- Completely redesigned splash screen for a more polished first impression
- Sleeker login experience that's both beautiful and functional
- Revamped user consent flow that's clearer and more intuitive
- Modernized profile interface that puts you in control
- Enhanced location screen with improved usability

### v1.1.11

- Minor bug fixes and performance improvements for login experience

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
