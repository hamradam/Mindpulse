//
//  TimeWheelPickerView.swift
//  MindPulse Watch Watch App
//
//  Created by Petra  Šátková on 24.01.2026.
//

import SwiftUI

struct TimeWheelPickerView: View {
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 5) {
                HStack(spacing: 2) {
                    wheelPicker(value: $hours, range: 0...23)
                    Text(":")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.bottom, 2)
                    wheelPicker(value: $minutes, range: 0...59)
                    Text(":")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.bottom, 2)
                    wheelPicker(value: $seconds, range: 0...59)
                }
            }
        }
    }

    // A reusable wheel
    private func wheelPicker(value: Binding<Int>, range: ClosedRange<Int>) -> some View {
        Picker("", selection: value) {
            ForEach(range, id: \.self) { n in
                Text(String(format: "%02d", n))
                    .font(.headline)
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .tag(n)
            }
        }
        .labelsHidden()
        .pickerStyle(.wheel)
        .frame(width: 45, height: 55) // controls wheel “window”
    }
}

