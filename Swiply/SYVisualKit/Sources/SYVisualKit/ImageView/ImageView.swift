import SwiftUI

public struct ImageView: View {

    let image: CardLoadableImage

    public var body: some View {
        switch image {
        case let .image(image):
            image
                .centerCropped()

        case .loading:
            Rectangle()
                .foregroundStyle(.gray)
        }
    }

}

//#Preview {
//    ImageView(image: Image(.card))
//}
