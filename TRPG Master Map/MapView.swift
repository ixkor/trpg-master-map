//
//  MapView.swift
//  TRPG Master Map
//
//  Created by Alexey Skoryatin on 20.11.2021.
//

import SwiftUI

struct MapView: View {
    
    @EnvironmentObject var appState: AppState
    var opacity: Double
    var showGrid: Bool
    var useRotate: Bool = false
    
    let blurSize: CGFloat = 5
    
    var body: some View {
        let image = appState.image
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            Image(nsImage: image ?? NSImage.init())
                .resizable()
                .aspectRatio(contentMode: .fit)
            GeometryReader { geometry in
                ZStack {
                    Canvas(renderer: drawMap)
                        .opacity(opacity)
                        .blur(radius: blurSize)
                    if showGrid {
                        Canvas(renderer: drawGrid)
                            .opacity(opacity)
                    }
                }
                .gesture(DragGesture(minimumDistance: 0).onChanged( { value in
                    onPoint(value.location, geometry.size)
                }))
            }
        }
        .rotationEffect(.degrees((useRotate && appState.rotate) ? 180 : 0))
    }
    
    private func onPoint(_ location: CGPoint, _ size: CGSize) {
        guard let map = appState.calcMap(size) else { return }
        let x = Int((location.x - map.ox) / map.dx)
        let y = Int((location.y - map.oy) / map.dy)
        if (x < 0 || y < 0 || x >= Int(appState.width) || y >= Int(appState.height)) {
            return
        }
        let i = y * Int(appState.width) + x
        appState.fog[i] = 0
    }
    
    private func drawMap(_ context: inout GraphicsContext, _ size: CGSize) {
        guard let map = appState.calcMap(size) else { return }
        for (i, v) in appState.fog.enumerated() {
            let x = CGFloat(i % Int(appState.width))
            let y = CGFloat(i / Int(appState.width))
            context.fill(
                Path(CGRect(
                    x: x * map.dx + map.ox - blurSize,
                    y: y * map.dy + map.oy - blurSize,
                    width: map.dx + 1 + blurSize * 2,
                    height: map.dy + 1 + blurSize * 2
                )),
                with: .color(.black.opacity(v))
            )
        }
    }
    
    private func drawGrid(_ context: inout GraphicsContext, _ size: CGSize) {
        guard let map = appState.calcMap(size) else { return }
        for l in 1..<Int(appState.width) {
            let x = CGFloat(l) * map.dx + map.ox
            var path = Path()
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: size.height))
            context.stroke(
                path,
                with: .color(.white),
                lineWidth: 1
            )
        }
        for c in 1..<Int(appState.height) {
            let y = CGFloat(c) * map.dy + map.oy
            var path = Path()
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: size.width, y: y))
            context.stroke(
                path,
                with: .color(.white),
                lineWidth: 1
            )
        }
    }
}



