import SwiftUI

// MARK: - ImageState

public enum ImageState: Equatable {
    case loading
    case image(ImageInfo)
}

public struct ImageInfo: Equatable {
    public var image: UIImage
    public var uuid: String
    
    public init(image: UIImage, uuid: String) {
        self.image = image
        self.uuid = uuid
    }
}
