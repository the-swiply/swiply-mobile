import SwiftUI

public struct SYFlowView<ContentView: View>: View {

    @State private var containerSize: CGSize = .zero

    private var content: [ContentView]
    private var padding: CGFloat
    private var geometry: GeometryProxy?
    
    public init(
        content: [ContentView],
        padding: CGFloat = 8,
        geometry: GeometryProxy? = nil
    ) {

        self.content = content
        self.padding = padding
    }

    public var body: some View {
        SYFlowContainerView(
            content: content,
            padding: padding,
            size: $containerSize,
            geometry: geometry
        )
        .frame(maxHeight: containerSize.height)
    }

}

#Preview {
    SYFlowView(content: [EmptyView()])
}
