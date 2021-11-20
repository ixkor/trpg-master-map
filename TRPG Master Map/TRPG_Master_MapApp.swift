//
//  TRPG_Master_MapApp.swift
//  TRPG Master Map
//
//  Created by Alexey Skoryatin on 10.11.2021.
//

import SwiftUI

@main
struct TRPG_Master_MapApp: App {
    let appState = AppState.shared

    var body: some Scene {
        WindowGroup("Master map") {
            ContentView()
                .environmentObject(appState)
        }
        WindowGroup("Players map") {
            PlayersView()
                .environmentObject(appState)
        }
    }
}
