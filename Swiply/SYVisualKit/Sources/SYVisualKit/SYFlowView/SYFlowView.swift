import SwiftUI

public struct SYFlowView<ContentView: View>: View {

    @State private var containerSize: CGSize = .zero

    private var content: [ContentView]
    private var padding: CGFloat

    public init(
        content: [ContentView],
        padding: CGFloat = 8
    ) {

        self.content = content
        self.padding = padding
    }

    public var body: some View {
        SYFlowContainerView(
            content: content,
            padding: padding,
            size: $containerSize
        )
        .frame(maxHeight: containerSize.height)
    }

}

#Preview {
    SYFlowView(content: [EmptyView()])
}
