import SwiftUI

struct SYFlowContainerView<ContentView: View>: View {

    private let content: [ContentView]
    private let padding: CGFloat
    
    @Binding var size: CGSize
    let geometry: GeometryProxy?
    
    init(content: [ContentView],
         padding: CGFloat,
         size: Binding<CGSize>,
         geometry: GeometryProxy? = nil) {
        
        self.content = content
        self.padding = padding
        self._size = size
        self.geometry = geometry
    }

    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        VStack {
            GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                    ForEach(content.indices, id: \.self) { index in
                        content[index]
                            .alignmentGuide(.leading) { dimension in
                                let geometryProxy = geometry ?? geo
                                if (abs(width - dimension.width) > geometryProxy.size.width) {
                                    width = 0
                                    height -= dimension.height + padding
                                }

                                let result = width

                                if index == content.endIndex - 1 {
                                    width = 0
                                }
                                else {
                                    width -= dimension.width + padding
                                }

                                return result
                            }
                            .alignmentGuide(.top) { dimension in
                                let result = height

                                if index == content.endIndex - 1 {
                                    height = 0
                                }

                                return result
                            }
                    }
                }
                .overlay {
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: SizePreferenceKey.self, value: proxy.size)
                    }
                }
                .onPreferenceChange(SizePreferenceKey.self) { preferences in
                    self.size = preferences
                }
            }
        }
    }
}

private struct SizePreferenceKey: PreferenceKey {

    typealias Value = CGSize

    static var defaultValue: Value = .zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }

}
