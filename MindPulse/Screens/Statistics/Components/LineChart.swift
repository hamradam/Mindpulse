//
//  StatsChart.swift
//  MindPulse
//
//  Created by Petra  Šátková on 27.01.2026.
//

import SwiftUI
import Charts

struct LineChart: View {
    let points: [DayMinutes]

    var body: some View {
        Chart(points) { p in
            BarMark(
                x: .value("Day", p.label),
                y: .value("Minutes", p.minutes)
            )
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let m = value.as(Int.self) {
                        Text("\(m)m")   // show 15m, 30m...
                    }
                }
            }
        }
        .chartYScale(domain: 0...(points.map(\.minutes).max() ?? 0))
        .frame(height: 180)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.background)
        )
    }
}


