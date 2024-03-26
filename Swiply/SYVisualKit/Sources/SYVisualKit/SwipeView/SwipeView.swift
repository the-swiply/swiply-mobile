import SwiftUI

public enum SwipeDirection {
    case left, right, top, bottom
}

public struct CardSwiperView<Card: View>: View {

    @Binding var cards: [Card]

    var onCardSwiped: ((SwipeDirection, Int) -> Void)?
    var onCardDragged: ((SwipeDirection, Int, CGSize) -> Void)?
    var initialOffsetY: CGFloat = 5
    var initialRotationAngle: Double = 0.5

    public init(
        cards: Binding<[Card]>,
        onCardSwiped: ((SwipeDirection, Int) -> Void)? = nil,
        onCardDragged: ((SwipeDirection, Int, CGSize) -> Void)? = nil,
        initialOffsetY: CGFloat = 5,
        initialRotationAngle: Double = 0.5
    ) {
        self._cards = cards
        self.onCardSwiped = onCardSwiped
        self.onCardDragged = onCardDragged
        self.initialOffsetY = initialOffsetY
        self.initialRotationAngle = initialRotationAngle
    }

    public var body: some View {
        ZStack {
            ForEach(cards.indices, id: \.self) { index in
                BaseCardView(
                    index: index,
                    onCardSwiped: { swipeDirection in
                        onCardSwiped?(swipeDirection, index)
                    },
                    onCardDragged: { direction, index, offset in
                        onCardDragged?(direction, index, offset)
                    },
                    content: {
                        cards[index]
                    },
                    initialOffsetY: initialOffsetY,
                    initialRotationAngle: initialRotationAngle,
                    zIndex: Double(cards.count - index)
                )
                .id(UUID())
            }
        }
    }
}
