//
//  WatchActivitiesView.swift
//  MindPulse
//
//  Created by Adam Hamr on 20.01.2026.
//

import SwiftUI

struct WatchActivitiesView: View {
    
    let activities = ActivityModel.sampleData
    @State var viewModel: WatchViewModel
    @State private var path = NavigationPath()
    
    var body: some View {
        let activities = viewModel.state.activities
        NavigationStack(path: $path) {
            Group {
                if activities.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "list.clipboard")
                            .font(.system(size: 40))
                            .foregroundStyle(.secondary)
                        Text("No activities")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Add new activity in iPhone.")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .scenePadding()
                } else {
                    ScrollView {
                        VStack(spacing: -20) {
                            ForEach(Array(activities.enumerated()), id: \.element.id) { index, activity in
                                WatchActivityCard(activity: activity)
                                    .containerRelativeFrame(.vertical, count: 1, spacing: 0)
                                    .scrollTransition(.interactive, axis: .vertical) { content, phase in
                                        content
                                            .scaleEffect(phase.value < 0 ? 1.0 : (phase.isIdentity ? 1.0 : 0.8), anchor: .bottom)
                                            .opacity(phase.value < 0 ? (1.0 + phase.value) : (phase.isIdentity ? 1.0 : 0.5))
                                            .blur(radius: phase.value < 0 ? 0 : (phase.isIdentity ? 0 : 2))
                                            .offset(y: phase.value < 0 ? phase.value * 130 : (phase.value > 0 ? -50 : 0))
                                    }
                                    .zIndex(Double(activities.count - index))
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .navigationTitle("MindPulse")
                }
            }
            .navigationDestination(for: ActivityModel.self) { activity in
                TimerView(viewModel: viewModel, activity: activity, path: $path)
            }
            .navigationDestination(for: RunningSession.self) { session in
                WatchActivityRunningView(activity: session.activity, totalTime: session.totalTime, path: $path)
            }
        }
        .onAppear {
            viewModel.fetchActivities()
        }
    }
}

#Preview {
    WatchActivitiesView(viewModel: WatchViewModel())
}
