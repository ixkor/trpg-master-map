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

    var body: some View {
        let image = appState.image!
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            GeometryReader { geometry in
                Canvas { context, size in
                    let imageSize = CGSize(
                        width: image.size.width - appState.insets.trailing,
                        height: image.size.height - appState.insets.bottom
                    )
                    let sx = size.width / imageSize.width
                    let sy = size.height / imageSize.height
                    let s = min(sx, sy)
                    let ox = (size.width - imageSize.width * s - appState.insets.trailing) / 2 + appState.insets.leading
                    let oy = (size.height - imageSize.height * s - appState.insets.bottom) / 2 + appState.insets.top
                    let dx = imageSize.width / CGFloat(appState.width)
                    let dy = imageSize.height / CGFloat(appState.height)
                    for (i, v) in appState.fog.enumerated() {
                        let x = CGFloat(i % Int(appState.width))
                        let y = CGFloat(i / Int(appState.width))
                        context.fill(
                            Path(CGRect(
                                x: x * dx * s + ox,
                                y: y * dy * s + oy,
                                width: dx * s + 1,
                                height: dy * s + 1
                            )),
                            with: .color(.black.opacity(v))
                        )
                    }
                    if showGrid {
                        for l in 1..<Int(appState.width) {
                            let x = CGFloat(l) * dx * s + ox
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
                            let y = CGFloat(c) * dy * s + oy
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
                .opacity(opacity)
                .gesture(DragGesture(minimumDistance: 0).onChanged( { value in
                    let imageSize = CGSize(
                        width: image.size.width - appState.insets.trailing,
                        height: image.size.height - appState.insets.bottom
                    )
                    let size = geometry.size
                    let sx = size.width / imageSize.width
                    let sy = size.height / imageSize.height
                    let s = min(sx, sy)
                    let ox = (size.width - imageSize.width * s - appState.insets.trailing) / 2 + appState.insets.leading
                    let oy = (size.height - imageSize.height * s - appState.insets.bottom) / 2 + appState.insets.top
                    let dx = image.size.width / CGFloat(appState.width)
                    let dy = image.size.height / CGFloat(appState.height)
                    
                    let x = Int((value.location.x - ox) / s / dx)
                    let y = Int((value.location.y - oy) / s / dy)
                    if (x < 0 || y < 0 || x >= Int(appState.width) || y >= Int(appState.height)) {
                        return
                    }
                    let i = y * Int(appState.width) + x
                    appState.fog[i] = 0
                }))
            }
        }
        .rotationEffect(.degrees((useRotate && appState.rotate) ? 180 : 0))
    }
    
}

