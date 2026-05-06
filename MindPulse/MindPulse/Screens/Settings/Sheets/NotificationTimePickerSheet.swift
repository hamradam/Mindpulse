//
//  NotificationTimePickerSheet.swift
//  MindPulse
//
//  Created by Petra  Šátková on 28.01.2026.
//

import SwiftUI

struct NotificationTimePickerSheet: View {
    @Binding var time: Date
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()

                Button("Save") {
                    onSave()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Daily reminder")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
