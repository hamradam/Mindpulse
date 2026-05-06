//
//  ActivitiesView.swift
//  MindPulse
//
//  Created by Adam Hamr on 25.11.2025.
//

import SwiftUI

@available(iOS 26.0, *)
struct ActivitiesView: View{
    
    @State var viewModel: ActivitiesViewModel
    
    init(viewModel: ActivitiesViewModel) {
        self.viewModel = viewModel
    }
    
    //@EnvironmentObject var themeManager: ThemeManager
    //@StateObject var themeManager = ThemeManager()
    
    @State private var path = NavigationPath()
    
    var body: some View{
        NavigationStack(path: $path){
            ScrollView {
                if viewModel.state.activities.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "list.clipboard")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        Text("No Activities")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Start with adding new activity!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 100)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.state.activities) { activity in
                            NavigationLink(value: activity) {
                                ActivityCard(
                                    emoji: activity.emoji,
                                    title: activity.name,
                                    cardColor: activity.color.swiftUIColor
                                )
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .destructive) {
                                    viewModel.deleteActivity(activityId: activity.id)
                                } label: {
                                    Label("Smazat", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationDestination(for: ActivityModel.self) { activity in
                ActivitySetupView(path: $path, activity: activity)
            }
        }
        .themedBackground()
        .onAppear {
            viewModel.fetchActivities()
        }
    }
}

