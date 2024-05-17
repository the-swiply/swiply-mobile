import SwiftUI

public struct ImageScrollingView: View {

    let images: [CardLoadableImage]
    let onTapCenter: (() -> Void)?

    @State var currentIndex = 0
    @State var viewSize: CGSize = .zero

    public init(images: [CardLoadableImage], onTapCenter: (() -> Void)?) {
        self.images = images
        self.onTapCenter = onTapCenter
    }

    public var body: some View {
        if !images.isEmpty, images[0] != .loading {
            ZStack(alignment: .top) {
                ImageView(image: images[currentIndex])
                    .id(currentIndex)
                    .transition(.opacity.animation(.default))
                    .overlay {
                        ImageScrollingOverlay(
                            maxIndex: images.count - 1,
                            onTapCenter: onTapCenter,
                            currentImageIndex: $currentIndex
                        )
                    }
                    .contentSize(in: $viewSize)

                if images.count > 1 {
                    CurrentImageIndicatorView(
                        currentImageIndex: currentIndex,
                        imageCount: images.count,
                        parentSize: viewSize
                    )
                    .padding(.top, 10)
                }
            }
        }
        else {
            Rectangle()
                .foregroundStyle(.gray)
                .overlay(.ultraThinMaterial)
        }
    }

}

//#Preview {
//    ImageScrollingView(images: [Image(.night), Image(.card)], onTapCenter: nil)
//}
