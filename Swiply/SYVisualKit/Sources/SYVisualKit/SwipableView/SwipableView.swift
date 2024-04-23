import SwiftUI

public struct SwipableView<WrappedView: View>: View {

    private var wrappedView: WrappedView

    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    @State private var opacity: CGFloat = 1

    public init(@ViewBuilder wrappedView: () -> WrappedView) {
        self.wrappedView = wrappedView()
    }

    public var body: some View {
        wrappedView
//            .onReceive(, perform: { _ in
//
//            })
            .offset(x: xOffset)
            .rotationEffect(.degrees(degrees))
            .animation(.bouncy(extraBounce: 0.1), value: xOffset)
            .highPriorityGesture(
                DragGesture()
                    .onChanged(onDragChanged)
                    .onEnded(onDragEnded)
            )
            .opacity(opacity)
    }
    
}

private extension SwipableView {

    func returnToCenter() {
        xOffset = 0
        degrees = 0
    }

    func swipeRight() {
        withAnimation {
            xOffset = 500
            degrees = 12
        } completion: {
            opacity = 0
        }
    }

    func swipeLeft() {
        withAnimation {
            xOffset = -500
            degrees = -12
        } completion: {
            opacity = 0
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
            swipeRight()
        }
        else {
            swipeLeft()
        }
    }

}

//#Preview {
//    SwipableView {
//        ImageView(image: Image(.))
//    }
//}
