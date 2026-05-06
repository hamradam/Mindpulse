//
//  NewActivityButton.swift
//  MindPulse
//
//  Created by Adam Hamr on 28.12.2025.
//

import SwiftUI

struct NewActivityButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.largeTitle.weight(.semibold))
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
                .background(themeManager.currentTheme.gradient)
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
        }
    }
}

#Preview {
    NewActivityButton(action: {})
        .environmentObject(ThemeManager())
}
