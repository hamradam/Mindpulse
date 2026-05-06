//
//  StatisticsDetailView.swift
//  MindPulse
//
//  Created by Petra  Šátková on 25.01.2026.
//

import SwiftUI

struct StatisticsDetailView: View {
    var selectedRecord: RecordModel
    @State var viewModel: StatisticsViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showFocusInfo: Bool = false
    
    
    var body: some View {
        

        
        ScrollView {
            VStack(spacing: 25) {
                // 1. Header with Duration and Date
                VStack(spacing: 4) {
                    Text(selectedRecord.date.formatted(date: .long, time: .omitted))
                        .font(.headline)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "timer")
                            .font(.caption)
                        Text(DurationFormatter.formatSeconds(seconds: Int(selectedRecord.durationSeconds)))
                            .font(.subheadline)
                    }
                    .foregroundStyle(.secondary)
                    .fontWeight(.medium)
                }
                .padding(.top, 10)
                
                // 2. Heart Rate Chart
                VStack(alignment: .leading, spacing: 10) {
                    Text("Heart Rate Activity")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    HRChart(samples: viewModel.state.hrSamples)
                        .padding(.horizontal)
                }

                // 3. Focus Score Card (Full width purple card)
                if let focusScore = viewModel.state.focusScore {
                    HStack(spacing: 12) {
                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                        
                        HStack(spacing: 6) {
                            Text("Focus Score")
                                .font(.headline)
                            
                            Button {
                                showFocusInfo = true
                            } label: {
                                Image(systemName: "info.circle")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        }
                        
                        Spacer()
                        
                        Text("\(focusScore)%")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                    }
                    .padding(20)
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal)
                    .shadow(color: .purple.opacity(0.2), radius: 10, y: 5)
                    .popover(isPresented: $showFocusInfo) {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                    .font(.title)
                                    .foregroundStyle(.purple)
                                Text("Focus Score")
                                    .font(.title2.bold())
                            }
                            
                            Text("Focus Score represents your heart rate stability during an activity. By analyzing how much your heart rate fluctuates (Heart Rate Variability), we can estimate your level of concentration.")
                                .font(.body)
                                .foregroundStyle(.secondary)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Label("High Score (80%+): Deep concentration and flow state.", systemImage: "bolt.fill")
                                Label("Medium Score: Steady activity with balanced focus.", systemImage: "checkmark.circle.fill")
                                Label("Low Score: High physiological variability or active movement.", systemImage: "exclamationmark.triangle.fill")
                            }
                            .font(.subheadline)
                            
                            Spacer()
                        }
                        .padding(30)
                        .presentationDetents([.medium])
                    }
                }
                
                // 4. Activity Metrics - Large Layout
                VStack(spacing: 12) {
                    // Average BPM (Full Width)
                    StatsCard(
                        title: "Average Heart Rate",
                        value: viewModel.state.avgHR != nil ? "\(viewModel.state.avgHR!) BPM" : "--",
                        icon: "heart.fill"
                    )
                    
                    // Min & Max (Side by Side)
                    HStack(spacing: 12) {
                        StatsCard(
                            title: "Min",
                            value: viewModel.state.minHR != nil ? "\(viewModel.state.minHR!)" : "--",
                            icon: "arrow.down"
                        )
                        StatsCard(
                            title: "Max",
                            value: viewModel.state.maxHR != nil ? "\(viewModel.state.maxHR!)" : "--",
                            icon: "arrow.up"
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
        .padding()
        .navigationTitle(LocalizedStringKey(viewModel.getActivityNameByRecord(record: selectedRecord)))
        .themedBackground()
        .onAppear {
            viewModel.fetchHrSamplesByRecord(record: selectedRecord)
        }
    }
}

#Preview {
//    StatisticsDetailView()
}
