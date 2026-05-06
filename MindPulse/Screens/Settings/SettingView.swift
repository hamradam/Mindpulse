//
//  SettingView.swift
//  MindPulse
//
//  Created by Adam Hamr on 25.11.2025.
//

import SwiftUI

enum ActiveSheet: Identifiable{
    case themeSelector
    case notificationSettings
    
    var id: Int{
        hashValue
    }
}

struct SettingView: View {
    
    var notificationManager: NotificationManaging = DIContainer.shared.resolve()
    
    @State private var activeSheet: ActiveSheet?
    
    @EnvironmentObject var themeManager: ThemeManager
    private let appVersion: String = Bundle.main.appVersion ?? "-"
    
    @State private var showNotifMenu = false
    @State private var showTimePicker = false
    @State private var notifTime = Calendar.current.date(from: DateComponents(hour: 21, minute: 10)) ?? Date()
    @State private var notifEnabled = false

    
    var body: some View {
        VStack{
            SettingCard(title: "Theme", subtitle: LocalizedStringKey(themeManager.currentTheme.name), buttonText: "Select", accessibilityTag: .settingThemeButton){
                activeSheet = .themeSelector
            }
            SettingCard(
                title: "Notifications",
                subtitle: notifEnabled ? LocalizedStringKey(timeString(notifTime)) : "Off",
                buttonText: "Set"
            ) {
                showNotifMenu = true
            }
            .confirmationDialog("Notifications", isPresented: $showNotifMenu, titleVisibility: .visible) {

                Button("Change time…") {
                    showTimePicker = true
                }

//                Button(notifEnabled ? "Reschedule" : "Enable") {
//                    Task {
//                        let granted = await notificationManager.requestPermission()
//                        guard granted else { return }
//
//                        let (h, m) = hourMinute(from: notifTime)
//                        notificationManager.cancelDaily()
//                        notificationManager.scheduleDailyNotification(hour: h, minute: m, testIn5Seconds: true)
//                        notifEnabled = true
//                    }
//                }

                if notifEnabled {
                    Button("Disable", role: .destructive) {
                        notificationManager.cancelDaily()
                        notifEnabled = false
                    }
                } else {
                    Button("Enable") {
                        Task {
                            let granted = await notificationManager.requestPermission()
                            guard granted else { return }

                            let (h, m) = hourMinute(from: notifTime)
                            notificationManager.cancelDaily()
                            notificationManager.scheduleDailyNotification(hour: h, minute: m, testIn5Seconds: false)
                            notifEnabled = true
                        }
                    }

                }

                Button("Cancel", role: .cancel) {}
            }
            .sheet(isPresented: $showTimePicker) {
                NotificationTimePickerSheet(
                    time: $notifTime,
                    onSave: {
                        Task {
                            let granted = await notificationManager.requestPermission()
                            guard granted else { return }

                            let (h, m) = hourMinute(from: notifTime)
                            notificationManager.cancelDaily()
                            notificationManager.scheduleDailyNotification(hour: h, minute: m, testIn5Seconds: false)
                            notifEnabled = true
                        }
                    }
                )
                .presentationDetents([.medium])
            }

            
            Spacer()
            
            SettingCard(title: "App version", subtitle: LocalizedStringKey(appVersion))
        }
        .padding(20)
        .themedBackground()
        .navigationTitle("Settings")
        .sheet(item: $activeSheet) { sheet in
            Group{
                switch sheet {
                case .themeSelector:
                    ThemeSelectorView(activeSheet: $activeSheet)
                case .notificationSettings:
                    Text("Notification settings")
                }
            }
            .preferredColorScheme(themeManager.currentTheme.isDark ? .dark : .light)

        }
    }
    
    private func hourMinute(from date: Date) -> (Int, Int) {
        let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
        return (comps.hour ?? 21, comps.minute ?? 0)
    }

    private func timeString(_ date: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        f.dateStyle = .none
        return f.string(from: date)
    }

}


extension Bundle{
    var appVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
    }
    
}
    
#Preview {
    SettingView()
        .environmentObject(ThemeManager())
}

