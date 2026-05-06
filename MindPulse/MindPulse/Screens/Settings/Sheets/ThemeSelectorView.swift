//
//  ThemeSelectorView.swift
//  MindPulse
//
//  Created by Adam Hamr on 26.11.2025.
//

import SwiftUI

struct ThemeSelectorView: View {

    @Binding var activeSheet: ActiveSheet?
    @EnvironmentObject var themeManager: ThemeManager

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16, alignment: .top),
        count: 3
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    ThemeSectionView(title: "Light", themes: themeManager.availableThemes.filter({!$0.isDark}), columns: columns)
                    
                    ThemeSectionView(title: "Dark", themes: themeManager.availableThemes.filter({$0.isDark}), columns: columns)
                }
                .padding()
            }
            .navigationTitle("Theme")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        activeSheet = nil
                    }
                    .accessibilityIdentifier(.themeSelectorCloseButton)
                }
            }
        }
        .background(themeManager.currentTheme.isDark ? Color.black : Color.white)
        .animation(.easeInOut(duration: 0.4), value: themeManager.currentTheme.isDark)
    }
}

struct ThemeSectionView: View {
    
    let title: LocalizedStringKey
    let themes: [Theme]
    let columns: [GridItem]
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        if !themes.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(themes) { theme in
                        
                        let isSelected = theme.id == themeManager.currentTheme.id
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(theme.gradient)
                                .frame(width: 100, height: 146)
                                .shadow(color: .black.opacity(0.25), radius: 8, y: 6)
                                .overlay {
                                    if isSelected {
                                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                                            .stroke(.white, lineWidth: 4)
                                            .shadow(color: .black.opacity(0.3), radius: 2)
                                    }
                                }
                                .scaleEffect(isSelected ? 1.05 : 1.0)
                            
                            Text(LocalizedStringKey(theme.name))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.primary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring()) {
                                themeManager.select(theme)
                            }
                        }
                        .applyAccessibilityIdentifier(for: theme)
                    }
                }
            }
        }
    }
}

extension View {
    @ViewBuilder
    func applyAccessibilityIdentifier(for theme: Theme) -> some View {
        switch theme.id {
        case "calmDawn":
            self.accessibilityIdentifier(.themeOptionCalmDawn)
        case "twilightBloom":
            self.accessibilityIdentifier(.themeOptionTwilightBloom)
        default:
            self
        }
    }
}
