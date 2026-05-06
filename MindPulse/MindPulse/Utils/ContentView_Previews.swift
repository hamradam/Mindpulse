//
//  ContentView_Previews.swift
//  MindPulse
//
//  Created by Petra  Šátková on 20.01.2026.
//

import SwiftUI

@available(iOS 26.0, *)
struct ContentView_Previews: PreviewProvider {

    static var previews: some View {

        ContentView().environmentObject({ () -> ThemeManager in
                    let envObj = ThemeManager()
                    return envObj
                }() )

    }
}
