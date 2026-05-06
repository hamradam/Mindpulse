//
//  WatchActivityCard.swift
//  MindPulse
//
//  Created by Adam Hamr on 20.01.2026.
//

import SwiftUI

struct WatchActivityCard: View {
    let activity: ActivityModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                HStack {
                    Text(activity.name)
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: activity.hrRecording ? "heart.fill" : "heart.slash.fill")
                        .font(.caption2)
                        .foregroundStyle(.black.opacity(0.3))
                }
                Spacer()
                Text(activity.emoji).font(.system(size: 60))
            }
            .padding()
            
            NavigationLink(value: activity) {
                Image(systemName: "play.fill")
                    .font(.title3)
                    .foregroundStyle(.black)
                    .frame(width: 48, height: 48)
                    .background(Color(red: 0.75, green: 0.95, blue: 0.45))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .padding(10)
        }
        .frame(height: 140)
        .background(activity.color.swiftUIColor.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal)
    }
}

