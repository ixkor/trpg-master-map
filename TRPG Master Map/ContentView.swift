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
    
    private let stateType: UTType = UTType(exportedAs: "net.xkor.tms")
    
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Grid options")) {
                    HStack {
                        Text("Colums")
                        Spacer()
                        Text(String(Int(appState.width)))
                        Button(action: { appState.width -= 1 }) { Text("-") }
                        Button(action: { appState.width += 1 }) { Text("+") }
                    }
                    HStack {
                        Text("Rows")
                        Spacer()
                        Text(String(Int(appState.height)))
                        Button(action: { appState.height -= 1 }) { Text("-") }
                        Button(action: { appState.height += 1 }) { Text("+") }
                    }
                }
                
                Section(header: Text("Insets")) {
                    HStack {
                        Text("Left")
                        Spacer()
                        Text(String(Int(appState.insets.leading)))
                        Button(action: { appState.insets.leading -= 1 }) { Text("-") }
                        Button(action: { appState.insets.leading += 1 }) { Text("+") }
                    }
                    HStack {
                        Text("Right")
                        Spacer()
                        Text(String(Int(appState.insets.trailing)))
                        Button(action: { appState.insets.trailing -= 1 }) { Text("-") }
                        Button(action: { appState.insets.trailing += 1 }) { Text("+") }
                    }
                    HStack {
                        Text("Top")
                        Spacer()
                        Text(String(Int(appState.insets.top)))
                        Button(action: { appState.insets.top -= 1 }) { Text("-") }
                        Button(action: { appState.insets.top += 1 }) { Text("+") }
                    }
                    HStack {
                        Text("Bottom")
                        Spacer()
                        Text(String(Int(appState.insets.bottom)))
                        Button(action: { appState.insets.bottom -= 1 }) { Text("-") }
                        Button(action: { appState.insets.bottom += 1 }) { Text("+") }
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .toolbar {
                Button(action: toggleSidebar) {
                    Label("Toggle sidebar", systemImage: "sidebar.left")
                }
            }
            VStack {
//                if let image = appState.image {
                    MapView(opacity: 0.5, showGrid: true)
                        .environmentObject(appState)
//                } else {
//                    Text("Select map image")
//                        .frame(width: 320)
//                }
            }
            .toolbar {
                Button(action: selectMapFile) {
                    Label("Select map image", systemImage: "map")
                }
                Button(action: openState) {
                    Label("Load state", systemImage: "square.and.arrow.up")
                }
                Button(action: saveState) {
                    Label("Save state", systemImage: "square.and.arrow.down")
                }
                Button(action: { appState.rotate = !appState.rotate}) {
                    Label("Rotate 180", systemImage: "rotate.left")
                }
            }
            
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .frame(
            minWidth: 200,
            maxWidth: .infinity,
            minHeight: 100,
            maxHeight: .infinity
        )
    }
    
    private func selectMapFile() {
        let openPanel = NSOpenPanel()
        openPanel.prompt = "Select File"
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedContentTypes = [UTType.png, UTType.jpeg]
        openPanel.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                appState.imageFile = openPanel.url!.path
            }
        }
    }
    
    private func openState() {
        let openPanel = NSOpenPanel()
        openPanel.prompt = "Select File"
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
//        openPanel.allowedContentTypes = [stateType]
//        openPanel.allowsOtherFileTypes = true
        openPanel.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                let decoder = JSONDecoder()
                if let data = try? Data(contentsOf: openPanel.url!),
                   let state = try? decoder.decode(AppState.self, from: data) {
                    appState.fill(state)
                }
            }
        }
    }
    
    private func saveState() {
        let panel = NSSavePanel()
        panel.prompt = "Select File"
        panel.canCreateDirectories = true
//        panel.allowedContentTypes = [stateType]
        panel.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                let encoder = JSONEncoder()
                if let jsondata = try? encoder.encode(appState),
                   let jsonstr = String(data: jsondata, encoding: .utf8) {
                    try? jsonstr.write(
                        toFile: panel.url!.path,
                        atomically: true,
                        encoding: .utf8
                    )
                }
            }
        }
    }
    
    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

