//
//  WatchActivityCompletedView.swift
//  MindPulse Watch Watch App
//
//  Created by Adam Hamr on 27.01.2026.
//

import SwiftUI

// Screena informujici o dokoncene aktivite
struct WatchActivityCompletedView: View {
    var activity: ActivityModel
    var duration: Int // in seconds
    @Binding var path: NavigationPath
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Well Done!")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top, 5)
            
            Text(activity.emoji)
                .font(.system(size: 30))
                .padding(.vertical, 2)
            
            Spacer()
            
            Text("You just finished your \(max(1, duration / 60)) minutes of \(Text(activity.name).font(.system(size: 15, weight: .bold)).foregroundColor(activity.color.swiftUIColor))!")
                .font(.system(size: 15))
                .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.7)
            .fixedSize(horizontal: false, vertical: true)
            .layoutPriority(1)
            .padding(.horizontal, 4)
                
            Spacer()
            
            Button(action: {
                path = NavigationPath() // Resetuje navigaci -> vrati nas na seznam
            }) {
                Text("Done")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.mint)
            .clipShape(Capsule())
            .padding(.bottom, 2)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    WatchActivityCompletedView(activity: .sampleData[0], duration: 300, path: .constant(NavigationPath()))
}
