import SwiftUI

struct BaseCardView<WrappedView: View>: View {

    var index: Int
    var onCardSwiped: ((SwipeDirection) -> Void)?
    var onCardDragged: ((SwipeDirection, Int, CGSize) -> Void)?
    var content: () -> WrappedView
    var initialOffsetY: CGFloat
    var initialRotationAngle: Double
    var zIndex: Double

    @State private var offset = CGSize.zero
    @State private var overlayColor: Color = .clear
    @State private var isRemoved = false
    @State private var activeCardIndex: Int?

    var body: some View {
        ZStack {
            content()
                .offset(x: offset.width * 1, y: offset.height * 0.4)
                .rotationEffect(.degrees(Double(offset.width / 40)))
                .zIndex(zIndex)

            Rectangle()
                .foregroundColor(overlayColor)
                .opacity(isRemoved ? 0 : (activeCardIndex == index ? 1 : 0))
                .cornerRadius(10)
                .blendMode(.overlay)
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = .init(width: gesture.translation.width, height: 0)

                    activeCardIndex = index
                    withAnimation {
                        handleCardDragging(offset)
                    }
                }
                .onEnded { gesture in
                    withAnimation {
                        handleSwipe(offsetWidth: offset.width, offsetHeight: offset.height)
                    }
                }
        )
        .opacity(isRemoved ? 0 : 1)
    }

    func handleCardDragging(_ offset: CGSize) {
        var swipeDirection: SwipeDirection = .left

        switch (offset.width, offset.height) {
        case (-500...(-150), _):
            swipeDirection = .left

        case (150...500, _):
            swipeDirection = .right

        case (_, -500...(-150)):
            swipeDirection = .top

        case (_, 150...500):
            swipeDirection = .bottom

        default:
            break
        }

        onCardDragged?(swipeDirection, index, offset)
    }

    func handleSwipe(offsetWidth: CGFloat, offsetHeight: CGFloat) {
        var swipeDirection: SwipeDirection = .left

        switch (offsetWidth, offsetHeight) {
        case (-500...(-150), _):
            swipeDirection = .left
            offset = CGSize(width: -500, height: 0)
            isRemoved = true
            onCardSwiped?(swipeDirection)

        case (150...500, _):
            swipeDirection = .right
            offset = CGSize(width: 500, height: 0)
            isRemoved = true
            onCardSwiped?(swipeDirection)

        case (_, -500...(-150)):
            swipeDirection = .top
            offset = CGSize(width: 0, height: 0)
            isRemoved = false
            onCardSwiped?(swipeDirection)

        case (_, 150...500):
            swipeDirection = .bottom
            offset = CGSize(width: 0, height: 0)
            isRemoved = false
            onCardSwiped?(swipeDirection)

        default:
            offset = .zero
            overlayColor = .clear
        }
    }
    
}
