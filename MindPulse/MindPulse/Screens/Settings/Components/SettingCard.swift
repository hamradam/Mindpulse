//
//  SettingCard.swift
//  MindPulse
//
//  Created by Adam Hamr on 25.11.2025.
//

import SwiftUI

struct SettingCard: View {
    var title: LocalizedStringKey
    var subtitle: LocalizedStringKey
    var buttonText: LocalizedStringKey?
    var accessibilityTag: AccessibilityTag? = nil
    var action: (() -> Void)?
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(title).font(.system(size: 22))
                Text(subtitle).font(.system(size: 16)).fontWeight(.semibold)
            }
            .padding(.leading,16).fontWeight(.bold)

            Spacer()
            
            if let buttonText = buttonText{
                Button(buttonText, action: action ?? {})
                .padding(.trailing,16)
                .accessibilityIdentifier(accessibilityTag?.rawValue ?? "")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 100)
        .background(themeManager.currentTheme.isDark ? Color.black : Color.white)
        .preferredColorScheme(themeManager.currentTheme.isDark ? .dark : .light)
        .cornerRadius(25)
    }
}
