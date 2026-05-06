# MindPulse 🏃‍♂️⌚️

MindPulse is an iOS and watchOS application designed for tracking physical activities, monitoring real-time heart rate, and visualizing workout statistics. 

## 🌟 Features

- **Activity Tracking**: Start and track various activities seamlessly from either your iPhone or Apple Watch.
- **Real-time Heart Rate Monitoring**: Integrates with Apple Watch sensors to read heart rate data during workouts.
- **Statistics & Charts**: Interactive custom charts on the iPhone to analyze your heart rate zones, activity duration, and overall performance.
- **Watch Syncing**: Real-time two-way synchronization between iOS and watchOS.
- **Custom Notifications**: Local notifications for workout reminders and goal achievements.
- **Dark/Light Mode**: Full support for iOS system appearance with custom color tokens.

## 🛠 Tech Stack & Architecture

- **Language**: Swift 5+
- **UI Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **Dependency Injection**: Custom DI container (`DIManager`)
- **Local Storage**: CoreData
- **Apple Frameworks**:
  - `HealthKit` (Heart rate and workout data integration)
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
- physical iPhone and Apple Watch for full testing (WatchConnectivity and HealthKit features are limited on the Simulator)
