//
//  PrimaryButtonStyle.swift
//  MindPulse
//
//  Created by Adam Hamr on 21.01.2026.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity) // Make the label expand to full width
            .padding(.vertical, 14)      // Vertical padding for height
            .background(
                LinearGradient(colors: [.teal, .cyan], startPoint: .bottomLeading, endPoint: .topTrailing)
            )
            .cornerRadius(14) // Rounded corners that can still stretch full width
            .shadow(color: .black.opacity(0.4), radius: 2)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .contentShape(Rectangle()) // Ensure full area is tappable
            .padding(.horizontal, 30)  // Optional: give some side margins; adjust or remove as needed
            .padding(.top, 10)
    }
}


extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}
