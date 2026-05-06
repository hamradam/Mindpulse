//
//  HRChart.swift
//  MindPulse
//
//  Created by Petra  Šátková on 27.01.2026.
//

import SwiftUI
import Charts

struct HRChart: View {
    let samples: [HeartRateSampleModel]

    private var points: [HRChartPoint] {
        guard let first = samples.min(by: { $0.timestamp < $1.timestamp })?.timestamp else { return [] }

        return samples
            .sorted(by: { $0.timestamp < $1.timestamp })
            .map { s in
                let minutes = s.timestamp.timeIntervalSince(first) / 60.0
                return HRChartPoint(id: s.id, minute: minutes, bpm: s.bpm)
            }
    }

    var body: some View {
        if points.isEmpty {
            ContentUnavailableView("No heart rate data", systemImage: "heart.slash.fill")
        } else {
            Chart(points) { p in
                LineMark(
                    x: .value("Minutes", p.minute),
                    y: .value("BPM", p.bpm)
                )
                PointMark(
                    x: .value("Minutes", p.minute),
                    y: .value("BPM", p.bpm)
                )
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let m = value.as(Double.self) {
                            Text("\(Int(round(m)))m")
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let bpm = value.as(Double.self) {
                            Text("\(Int(round(bpm)))")
                        }
                    }
                }
            }
            .chartYScale(domain: .automatic(includesZero: false))
            .frame(height: 180)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.background)
            )
        }
    }
}
