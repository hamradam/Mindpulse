//
//  ContentView.swift
//  MindPulse Watch Watch App
//
//  Created by Petra  Šátková on 20.01.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WatchActivitiesView(viewModel: WatchViewModel())
    }
}

#Preview {
    ContentView()
}
