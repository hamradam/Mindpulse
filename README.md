# MindPulse 🧘‍♀️📚🏃‍♂️⌚️

MindPulse is an iOS and watchOS application designed for tracking daily microhabits and activities—ranging from physical workouts to mindfulness, reading, cleaning, and deep work—with optional real-time heart rate monitoring and habit statistics.

## 🌟 Features

- **Microhabit & Activity Tracking**: Start and track various habits and activities (like meditation, reading, cleaning, or running) seamlessly from either your iPhone or Apple Watch.
- **Optional Real-time Heart Rate Monitoring**: Integrates with Apple Watch sensors to read heart rate data during habits that support tracking (such as workouts or meditation).
- **Statistics & Charts**: Interactive custom charts on the iPhone to analyze habit duration, performance patterns, and heart rate zones (for heart-rate-enabled activities).
- **Watch Syncing**: Real-time two-way synchronization between iOS and watchOS.
- **Custom Notifications**: Local notifications for habit reminders and goal achievements.
- **Dark/Light Mode**: Full support for iOS system appearance with custom color tokens.

## 🛠 Tech Stack & Architecture

- **Language**: Swift 5+
- **UI Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **Dependency Injection**: Custom DI container (`DIManager`)
- **Local Storage**: CoreData
- **Apple Frameworks**:
  - `HealthKit` (Heart rate and workout data integration for relevant activities)
  - `WatchConnectivity` (Communication between iPhone and Apple Watch)
  - `UserNotifications` (Local alerts)
- **Testing**: `XCTest` (Unit Tests & UI Tests)

## 🚀 How to Run
1. Clone the repository: `git clone https://github.com/yourusername/MindPulse.git`
2. Open `MindPulse.xcodeproj` in Xcode 15+.
3. Select your preferred Simulator or physical device.
4. Hit `Cmd + R` to build and run.

### Prerequisites
- macOS with Xcode 15 or later
- Physical iPhone and Apple Watch for full testing (WatchConnectivity and HealthKit features are limited on the Simulator)
