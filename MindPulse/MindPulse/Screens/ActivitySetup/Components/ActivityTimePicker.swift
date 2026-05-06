//
//  ActivityTimePicker.swift
//  MindPulse
//
//  Created by Adam Hamr on 21.01.2026.
//

import SwiftUI

struct ActivityTimePicker: View {
    
    @Binding var selectedMins: Int
    var themeManager: ThemeManager
    private let presets = [5, 10, 15, 20]
    
    var activity: ActivityModel
    
    var cardBackgroundColor: Color {
         themeManager.currentTheme.isDark ? Color(.systemGray6) : Color.white
     }
    
    var body: some View {
        HStack {
            Text("Duration")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.horizontal, 40)
        
        VStack(spacing: 20) {
            HStack(spacing: 12) {
                ForEach(presets, id: \.self){preset in
                    Button(action: {
                        withAnimation{
                            selectedMins = preset
                        }
                    }){
                        ZStack{
                            Circle()
                                .stroke(selectedMins == preset ? Color.blue : Color.black, lineWidth: selectedMins == preset ? 3 : 1.5)
                                .background(Circle().fill(Color.clear))
                                .frame(width: 55, height: 55)
                            
                            VStack(spacing: 0){
                                Text("\(preset)").font(.system(size: 18, weight: .bold))
                                Text("min").font(.system(size: 10))
                            }
                        }
                    }
                }
            }
            .padding(.top, 25)
            
            HStack{
                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                Text("OR").font(.caption).fontWeight(.semibold).foregroundColor(.gray).padding(.horizontal, 5)
                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
            }
            .padding(.horizontal, 20)
            
            Picker("Time", selection: $selectedMins){
                ForEach(1...60, id: \.self){num in
                    Text("\(num)").tag(num)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
            .padding(.bottom, 10)
        }
        .background(cardBackgroundColor)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        .padding(.horizontal, 30)
    }
}
