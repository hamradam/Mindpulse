//
//  ActivityCard.swift
//  MindPulse
//
//  Created by Adam Hamr on 25.11.2025.
//

import SwiftUI

struct ActivityCard: View{
    
    let emoji: String
    let title: String
    let cardColor: Color
    
    var body: some View{
        HStack(){
            Text(emoji).font(.system(size: 65))
                .padding(.leading,16)
            Text(title).font(.system(size: 24)).fontWeight(.medium).foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 100)
        .background(cardColor)
        .cornerRadius(25)
    }
}

#Preview{
    ActivityCard(
        emoji: "🧘‍♀️", title: "Meditation", cardColor: Color.red)
}
