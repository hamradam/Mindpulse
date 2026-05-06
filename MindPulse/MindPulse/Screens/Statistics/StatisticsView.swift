//
//  StatisticsView.swift
//  MindPulse
//
//  Created by Petra  Šátková on 24.01.2026.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @Binding var filteredActivity: ActivityModel?
    @State var viewModel: StatisticsViewModel = StatisticsViewModel()
    
    var recordsToShow: [RecordModel] {
        if let a = filteredActivity {
            return viewModel.fetchRecordsByActivity(activity: a)
        }
        return viewModel.state.records
    }

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 12) {
                    StatsCard(
                        title: "Sessions",
                        value: String(viewModel.state.totalCount),
                        icon: "calendar.badge.clock"
                    )
                    
                    StatsCard(
                        title: "Time",
                        value: "\(viewModel.state.totalMinutes)m",
                        icon: "clock.fill"
                    )
                }
                
                LineChart(points: viewModel.state.weeklyPoints ?? [])
                
                Text("Last sessions")
                    .font(Font.title3.bold())
                    .padding(.top, 10)
                
                LazyVStack(spacing: 12) {
                    ForEach(recordsToShow) { record in
                        NavigationLink {
                            StatisticsDetailView(selectedRecord: record, viewModel: viewModel)
                        } label: {
                            SessionRow(
                                title: filteredActivity == nil ? viewModel.getActivityNameByRecord(record: record) : filteredActivity?.name ?? "unknown",
                                value: String(DurationFormatter.formatSeconds(seconds: Int(record.durationSeconds))),
                                date: record.date
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchActivities()
            viewModel.fetchRecords()
            viewModel.calculateTotalTime(activity: nil)
            viewModel.calculateTotalCount(activity: nil)
            viewModel.minutesByDayForCurrentWeek(records: recordsToShow)
        }
        .onChange(of: filteredActivity) { _, newValue in
            viewModel.calculateTotalTime(activity: newValue)
            viewModel.calculateTotalCount(activity: newValue)
            viewModel.minutesByDayForCurrentWeek(records: recordsToShow)
        }
    }
}

#Preview {
//    StatisticsView()
//        .environmentObject(ThemeManager())
}
