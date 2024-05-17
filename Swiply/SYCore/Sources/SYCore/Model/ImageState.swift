import SwiftUI

// MARK: - ImageState

public enum ImageState: Equatable {
    case loading
    case image(UIImage)
}
