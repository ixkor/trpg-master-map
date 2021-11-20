//
//  ContentView.swift
//  TRPG Master Map
//
//  Created by Alexey Skoryatin on 10.11.2021.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState

    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }

    var body: some View {
        HStack {
            if let image = appState.image {
                VStack {
                    HStack {
                        Text("Left padding:")
                        Button(action: { appState.insets.leading -= 1 }) { Text("-") }
                        Text(String(Int(appState.insets.leading)))
                        Button(action: { appState.insets.leading += 1 }) { Text("+") }

                        Slider(value: $appState.width, in: 2...100, step: 1)
                            .frame(width: 400, alignment: .center)
                        Text("Width: " + String(Int(appState.width)))

                        Text("Right padding:")
                        Button(action: { appState.insets.trailing -= 1 }) { Text("-") }
                        Text(String(Int(appState.insets.trailing)))
                        Button(action: { appState.insets.trailing += 1 }) { Text("+") }
                    }
                    HStack {
                        Text("Top padding:")
                        Button(action: { appState.insets.top -= 1 }) { Text("-") }
                        Text(String(Int(appState.insets.top)))
                        Button(action: { appState.insets.top += 1 }) { Text("+") }
                        
                        Slider(value: $appState.height, in: 2...100, step: 1)
                            .frame(width: 400, alignment: .center)
                        Text("Height: " + String(Int(appState.height)))

                        Text("Bottom padding:")
                        Button(action: { appState.insets.bottom -= 1 }) { Text("-") }
                        Text(String(Int(appState.insets.bottom)))
                        Button(action: { appState.insets.bottom += 1 }) { Text("+") }
                    }
                    MapView(opacity: 0.5, showGrid: true)
                        .environmentObject(appState)
                }
            } else {
                Text("Drag and drop image file")
                    .frame(width: 320)
            }
        }
        .frame(
            minWidth: 200,
            maxWidth: .infinity,
            minHeight: 100,
            maxHeight: .infinity
        )
        .toolbar {
            Button(action: selectFile) {
                Text("Select map image")
            }
            Button(action: { appState.rotate = !appState.rotate}) {
                Text("Rotate")
            }
        }

    }
    
    private func selectFile() {
        let openPanel = NSOpenPanel()
        openPanel.prompt = "Select File"
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedContentTypes = [UTType.png, UTType.jpeg]
        openPanel.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                appState.image = NSImage.init(contentsOfFile: openPanel.url!.path)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
