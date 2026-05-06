//
//  NewActivityView.swift
//  MindPulse
//
//  Created by Adam Hamr on 28.12.2025.
//

import SwiftUI
import ElegantEmojiPicker

@available(iOS 26.0, *)
struct NewActivityView: View {
    @State var viewModel: ActivitiesViewModel
    
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    var watchConnector: WatchConnecting = DIContainer.shared.resolve()
    
    @State private var emoji: Emoji? = nil
    @State private var name: String = ""
    @State private var color: PaletteColor = .red
    @State private var HRisActive: Bool = false
    
    @State private var isEmojiPickerPresented: Bool = false
    
    var cardBackgroundColor: Color {
        themeManager.currentTheme.isDark ? Color(.systemGray6) : Color.white
    }
    
    var textColor: Color {
        themeManager.currentTheme.isDark ? .white : .black
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(action: {
                        isEmojiPickerPresented.toggle()
                    }){
                        VStack(spacing: 12) {
                            ZStack{
                                Circle()
                                    .stroke(textColor.opacity(0.8), lineWidth: 2)
                                    .frame(width: 100, height: 100)
                                
                                Text(emoji?.emoji ?? "")
                                    .font(.system(size: 50))
                            }
                            .padding(.top, 10)
                            
                            Text("Tap to select emoji")
                                .font(.subheadline)
                                .foregroundColor(textColor)
                                .padding(.bottom, 10)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                    .emojiPicker(
                        isPresented: $isEmojiPickerPresented,
                        selectedEmoji: $emoji,
                        configuration: ElegantConfiguration(showRandom: false, showReset: false)
                    )
                }
                
                Section {
                    TextField("Activity name", text: $name)
                        .accessibilityIdentifier(.newActivityNameField)
                }
                
                Section("Customization") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Card color")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(PaletteColor.allCases, id: \.self) { paletteColor in
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            self.color = paletteColor
                                        }
                                    }) {
                                        ZStack {
                                            if self.color == paletteColor {
                                                Circle()
                                                    .stroke(textColor.opacity(0.5), lineWidth: 2)
                                                    .frame(width: 38, height: 38)
                                            }
                                            
                                            Circle()
                                                .fill(paletteColor.swiftUIColor)
                                                .frame(width: 30, height: 30)
                                        }
                                    }
                                }
                            }
                            .frame(height: 44)
                            .padding(.horizontal, 2)
                        }
                    }
                    .padding(.vertical, 12)
                    
                    Toggle("HR recording", isOn: $HRisActive)
                        .accessibilityIdentifier(.newActivityHRToggle)
                }
            }
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .accessibilityIdentifier(.newActivityCloseButton)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let newActivity = createActivity()
                        viewModel.addActivity(newActivity: newActivity)
                        watchConnector.sendActivity(activity: newActivity)
                        viewModel.fetchActivities()
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .accessibilityIdentifier(.newActivitySaveButton)
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func createActivity() -> ActivityModel {
        let activity = ActivityModel(
            id: UUID(),
            name: name,
            emoji: emoji?.emoji ?? "👀",
            color: color,
            hrRecording: HRisActive
        )
        return activity
    }
}
