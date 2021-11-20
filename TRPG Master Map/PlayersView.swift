//
//  ContentView.swift
//  TRPG Master Map
//
//  Created by Alexey Skoryatin on 10.11.2021.
//

import SwiftUI
import UniformTypeIdentifiers

struct PlayersView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack {
            if appState.image != nil {
                MapView(opacity: 1, showGrid: false, useRotate: true)
                    .environmentObject(appState)
            }
        }
        .frame(
            minWidth: 200,
            maxWidth: .infinity,
            minHeight: 100,
            maxHeight: .infinity
        )
    }
}

struct PlayersView_Previews: PreviewProvider {
    static var previews: some View {
        PlayersView()
    }
}
