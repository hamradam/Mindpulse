//
//  StatsCard.swift
//  MindPulse
//
//  Created by Petra  Šátková on 25.01.2026.
//

import SwiftUI
import Charts

struct StatsCard: View {
    var title: LocalizedStringKey
    var value: String
    var icon: String? = nil
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .black))
                    .foregroundStyle(.blue.gradient)
                    .frame(width: 38, height: 38)
                    .background(themeManager.currentTheme.isDark ? .white.opacity(0.12) : .black.opacity(0.06))
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .kerning(1.0)
                    .lineLimit(1)
                
                Text(value)
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(themeManager.currentTheme.isDark ? .white : .black)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                }
        }
    }
}

#Preview {
    StatsCard(title: "Total Sessions", value: "16")
        .environmentObject(ThemeManager())
}
