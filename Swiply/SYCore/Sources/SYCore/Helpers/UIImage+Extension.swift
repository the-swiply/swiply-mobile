import SwiftUI

public extension UIImage {

    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString()
    }
  
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }

}
