//
//  SessionRow.swift
//  MindPulse
//
//  Created by Petra  Šátková on 25.01.2026.
//

import SwiftUI

struct SessionRow: View {
    var title: String
    var value: String
    var date: Date
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(themeManager.currentTheme.isDark ? .white : .black)
                
                HStack(spacing: 4) {
                    Image(systemName: "timer")
                        .font(.caption2)
                    Text(value)
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(date, style: .date)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                
                Text(date, style: .time)
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.tertiary)
                .padding(.leading, 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        }
    }
}

#Preview {
    SessionRow(title: "Meditation", value: "1h 20min", date: Date())
        .environmentObject(ThemeManager())
}
