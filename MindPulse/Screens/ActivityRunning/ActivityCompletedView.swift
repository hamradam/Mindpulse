//
//  ActivityCompletedView.swift
//  MindPulse
//
//  Created by Adam Hamr on 27.01.2026.
//

import SwiftUI

struct ActivityCompletedView: View {
    var activity: ActivityModel
    var duration: Int // in seconds
    var onDone: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Well Done!")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding(.top, 20)
            
            Text(activity.emoji)
                .font(.system(size: 100))
                .padding(.vertical, 20)
            
            Text("You just finished your \(max(1, duration / 60)) minutes of \(Text(activity.name).font(.title3).fontWeight(.bold).foregroundColor(Color(activity.color.swiftUIColor)))!")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: {
                onDone()
            }) {
                Text("Done")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .tint(.mint)
            .clipShape(Capsule())
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .themedBackground()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ActivityCompletedView(activity: .sampleData[0], duration: 300, onDone: {})
        .environmentObject(ThemeManager())
}
