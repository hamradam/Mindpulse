//
//  DesignUtils.swift
//  MindPulse
//
//  Created by Adam Hamr on 26.11.2025.
//

import SwiftUI

struct BackgroundModifier: ViewModifier{
    @EnvironmentObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        ZStack{
            themeManager.currentTheme.gradient
                .ignoresSafeArea()
                .animation(.easeInOut, value: themeManager.currentTheme)
            
            content
        }
        .preferredColorScheme(themeManager.currentTheme.isDark ? .dark : .light)
    }
}

extension View{
    func themedBackground() -> some View{
        self.modifier(BackgroundModifier())
    }
}
