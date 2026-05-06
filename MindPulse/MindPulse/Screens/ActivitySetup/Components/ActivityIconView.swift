//
//  ActivityIconView.swift
//  MindPulse
//
//  Created by Adam Hamr on 21.01.2026.
//

import SwiftUI

struct ActivityIconView: View {
    
    var themeManager: ThemeManager
    var activity: ActivityModel
    
    var cardBackgroundColor: Color {
         themeManager.currentTheme.isDark ? Color(.systemGray6) : Color.white
     }
    
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(Color.black, lineWidth: 2)
                .frame(width: 200, height: 200)
                .background(cardBackgroundColor)
                .clipShape(.circle)
            
            Text(activity.emoji)
                .font(.system(size: 100))
        }
        .padding(.top, 20)
    }
}
