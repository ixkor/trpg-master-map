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
}
