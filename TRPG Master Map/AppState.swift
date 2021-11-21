import Combine
import Cocoa
import SwiftUI

class AppState: ObservableObject, Codable {
    
    static let shared = AppState()
    private init() {}

    @Published var image: NSImage? = nil
    
    var imageFile: String? = nil {
        didSet {
            if let path = imageFile {
                image = NSImage.init(contentsOfFile: path)
            }
        }
    }
    
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
    
    @Published var insets: Insets = Insets()
    
    private enum CodingKeys: String, CodingKey {
        case rotate, width, height, fog, imageFile, insets
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        rotate = try container.decode(Bool.self, forKey: .rotate)
        width = try container.decode(Float.self, forKey: .width)
        height = try container.decode(Float.self, forKey: .height)
        fog = try container.decode([Double].self, forKey: .fog)
        imageFile = try container.decode(String?.self, forKey: .imageFile)
        insets = try container.decode(Insets.self, forKey: .insets)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(rotate, forKey: .rotate)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(fog, forKey: .fog)
        try container.encode(imageFile, forKey: .imageFile)
        try container.encode(insets, forKey: .insets)
    }

    func fill(_ state: AppState) {
        rotate = state.rotate
        width = state.width
        height = state.height
        fog = state.fog
        imageFile = state.imageFile
        insets = state.insets
    }

    func calcMap(_ size: CGSize) -> MapParams? {
        guard let image = image else { return nil }

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

    struct Insets: Codable {
        var top: CGFloat = 0
        var leading: CGFloat = 0
        var bottom: CGFloat = 0
        var trailing: CGFloat = 0
    }
}
