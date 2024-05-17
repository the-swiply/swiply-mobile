import SwiftUI

public struct SwipableView<WrappedView: View, ID: Equatable>: View {

    private var wrappedView: WrappedView

    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    @State private var opacity: CGFloat = 1

    private var swipeAction: SwipeAction<ID>?
    private var id: ID

    public init(swipeAction: SwipeAction<ID>?, id: ID, @ViewBuilder wrappedView: () -> WrappedView) {
        self.wrappedView = wrappedView()
        self.id = id
        self.swipeAction = swipeAction
    }

    public var body: some View {
        wrappedView
            .offset(x: xOffset)
            .rotationEffect(.degrees(degrees))
            .animation(.bouncy(extraBounce: 0.1), value: xOffset)
            .highPriorityGesture(
                DragGesture()
                    .onChanged(onDragChanged)
                    .onEnded(onDragEnded)
            )
            .onChange(of: swipeAction) { _, newValue in
                handleSwipeAction(swipeAction: newValue)
            }
            .opacity(opacity)
    }
    
}

private extension SwipableView {

    func returnToCenter() {
        xOffset = 0
        degrees = 0
    }

    func swipeLeft() {
        withAnimation {
            xOffset = 500
            degrees = 12
        } completion: {
            opacity = 0
        }
    }

    func swipeRight() {
        withAnimation {
            xOffset = -500
            degrees = -12
        } completion: {
            opacity = 0
        }
    }

    func handleSwipeAction(swipeAction: SwipeAction<ID>?) {
        guard id == swipeAction?.id else {
            return
        }
        
        switch swipeAction {
        case .left:
            swipeLeft()

        case .right:
            swipeRight()

        case .none:
            break
        }
    }

}

private extension SwipableView {

    var swipeBorderValue: CGFloat { 250 }

    func onDragChanged(_ value: _ChangedGesture<DragGesture>.Value) {
        xOffset = value.translation.width
        degrees = Double(value.translation.width / 25)
    }

    func onDragEnded(_ value: _ChangedGesture<DragGesture>.Value) {
        let width = value.translation.width

        if abs(width) <= swipeBorderValue {
            returnToCenter()
            return
        }

        if width >= swipeBorderValue {
            swipeLeft()
        }
        else {
            swipeRight()
        }
    }

}

//#Preview {
//    SwipableView {
//        ImageView(image: Image(.))
//    }
//}
