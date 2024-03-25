import SwiftUI

public struct SYFlowView<ContentView: View>: View {

    @State private var containerSize: CGSize

    private var content: [ContentView]

    public init(content: [ContentView]) {
        self.containerSize = .zero
        self.content = content
    }

    public var body: some View {
        SYFlowContainerView(
            content: content,
            size: $containerSize
        )
        .frame(maxHeight: containerSize.height)
    }

}

#Preview {
    SYFlowView(content: [EmptyView()])
}
