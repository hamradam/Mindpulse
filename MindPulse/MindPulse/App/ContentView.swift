//
//  ContentView.swift
//  MindPulse
//
//  Created by Adam Hamr on 25.11.2025.
//

import SwiftUI

@available(iOS 26.0, *)
struct ContentView: View {
    // init for viewModel that is passed around
    var viewModel: ActivitiesViewModel = ActivitiesViewModel()
    
    @State var selectedTab = 0
    @State private var isSettingPresented: Bool = false
    @State private var isNewActivityPresented: Bool = false
    @State var isFilterPresented: Bool = false
    @State var filteredActivity: ActivityModel? = nil
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottomTrailing) {
                TabView(selection: $selectedTab) {
                    Tab("Activities", systemImage: "house.circle.fill", value: 0) {
                        ActivitiesView(viewModel: viewModel)
                        
                    }
                    .accessibilityIdentifier(.activitiesTab)
                    Tab("Statistics", systemImage: "list.bullet.circle", value: 1){
                        StatisticsView(filteredActivity: $filteredActivity).themedBackground()
                    }
                    .accessibilityIdentifier(.statisticsTab)
                }
                // plus button
                if selectedTab == 0 {
                    NewActivityButton {
                        isNewActivityPresented = true
                    }
                    .accessibilityIdentifier(.newActivityButton)
                    .sheet(isPresented: $isNewActivityPresented){
                        NewActivityView(viewModel: viewModel).presentationDetents([.fraction(0.8), .large])
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 60)
                }
            }
            .navigationTitle(selectedTab == 1 ? "Statistics" : "MindPulse")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if selectedTab == 1 {

                        Menu {
                            // "All"
                            Button {
                                filteredActivity = nil
                            } label: {
                                Label("All activities", systemImage: filteredActivity == nil ? "checkmark" : "")
                            }

                            // Activities list
                            ForEach(viewModel.state.activities) { activity in
                                Button {
                                    filteredActivity = activity
                                } label: {
                                    HStack {
                                        Text(activity.name)
                                        if filteredActivity == activity {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                        }
                    }

                    Button { isSettingPresented = true } label: {
                        Image(systemName: "gear")
                    }
                    .accessibilityIdentifier(.settingsButton)
                }
            }

            .navigationDestination(isPresented: $isSettingPresented) {
                SettingView()
            }
            
        }
        
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        ContentView()
            .environmentObject(ThemeManager())
    } else {
        // Fallback on earlier versions
    }
}
