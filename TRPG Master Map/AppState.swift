import Combine
import Cocoa
import SwiftUI

class AppState: ObservableObject {
    
    static let shared = AppState()
    private init() {}
    
    @Published var image: NSImage?
    
    @Published var rotate: Bool = false
    
    @Published var fog: [Double] = [1,1,1,1]
    
    @Published var width: Float = 2 {
        didSet {
            fog = Array(repeating: 1, count: Int(width * height))
        }
    }
    
    @Published var height: Float = 2 {
        didSet {
            fog = Array(repeating: 1, count: Int(width * height))
        }
    }
    
    @Published var insets: EdgeInsets = EdgeInsets()
    
    func calcMap(_ size: CGSize) -> MapParams {
        let image = image!
        let imageSize = image.size
        let sx = size.width / imageSize.width
        let sy = size.height / imageSize.height
        let s = min(sx, sy)
        return MapParams(
            ox: (size.width - imageSize.width * s) / 2 + insets.leading,
            oy: (size.height - imageSize.height * s) / 2 + insets.top,
            dx: (imageSize.width - insets.trailing) / CGFloat(width) * s,
            dy: (imageSize.height - insets.bottom) / CGFloat(height) * s
        )
    }
    
    struct MapParams {
        let ox, oy, dx, dy: CGFloat
    }
}
