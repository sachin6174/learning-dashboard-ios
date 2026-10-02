# Learning Dashboard (iOS)

Small SwiftUI assignment app. Open `LearningDashboard.xcodeproj` in Xcode, select an iOS Simulator, and Run. Enter any valid email and any nonempty password; authentication is mocked.

The [20-second demo](demo.mp4) shows login, courses, a lesson marked complete, and the saved 70% progress after relaunch. The [simulator screenshot](login.png) shows the login screen.

## Architecture

`Views` show state and send actions to `AppModel` (a small `ObservableObject`). `AppModel` owns login, loading, and lesson completion. `CourseRepository` reads bundled JSON and persists courses. This keeps UI, state, and storage separate without adding layers that this small app does not need.

## Offline support

After the first load, encoded courses are saved in `UserDefaults`. Later launches read that cache first, including when the device is offline. Lesson completion is saved immediately. The bundled JSON represents the mock API, so the demo does not require internet even for its first run. A real API would replace the bundled read and retain the same cache path.

## Security

Production authentication tokens belong in the iOS Keychain, never in `UserDefaults` or source code. This demo creates no token.

## Scale

For 1 million users and hundreds of courses, I would add server pagination, a real HTTP client with retries and timeouts, SQLite/SwiftData storage for larger datasets, authenticated progress synchronization with conflict handling, and observability for failures and latency.

## Second platform

On Android I would use Jetpack Compose screens, a ViewModel with StateFlow, a repository using Retrofit, and Room for offline storage. Tokens would use Android Keystore backed storage.

## Verification

Run the included tests in Xcode. The unit test checks that completing a lesson changes progress once; the UI test checks login, course navigation, lesson completion, and saved progress after relaunch.
