//
//  ActivitySetupView.swift
//  MindPulse
//
//  Created by Adam Hamr on 21.01.2026.
//

import SwiftUI

struct ActivitySetupView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State var selectedMins: Int = 10
    
    @State private var navigateToRunning = false
    @Binding var path: NavigationPath
    
    var activity: ActivityModel
    
    var body: some View {
        Group{
            VStack{
                ActivityIconView(themeManager: themeManager, activity: activity)
                ActivityTimePicker(selectedMins: $selectedMins, themeManager: themeManager, activity: activity)
                
                
                Button("Dive In"){
                    navigateToRunning.toggle()
                }.buttonStyle(.primary)
                    .navigationDestination(isPresented: $navigateToRunning) {
                        ActivityRunningView(activity: activity, totalTime: selectedMins * 60, path: $path)
                            .navigationBarBackButtonHidden(true)
                            .themedBackground()
                    }
               
            }
        }
        .navigationTitle(activity.name)
        .themedBackground()
    }
}
