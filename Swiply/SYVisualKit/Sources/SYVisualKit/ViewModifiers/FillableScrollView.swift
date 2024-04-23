import SwiftUI

#warning("TODO: Documentation")
#warning("TODO: Functionality like ViewModifier. Refactor to ViewModifier")

public struct FillableScrollView<Content>: View where Content : View {

    // MARK: - Private Properties

    @State private var axes: Axis.Set
    @State private var contentSize: CGSize = .zero

    private let showsIndicator: Bool
    private let content: Content

    // MARK: - Init

    public init(scrollView: ScrollView<Content>) {
        self._axes = .init(wrappedValue: scrollView.axes)
        self.showsIndicator = scrollView.showsIndicators
        self.content = scrollView.content
    }

    // MARK: - Protocol View

    public var body: some View {
        GeometryReader { geometry in
            ScrollView(axes, showsIndicators: showsIndicator) {
                content
                    .contentSize(in: $contentSize)
                    .onChange(of: contentSize) { newContentSize in
                        if newContentSize.height <= geometry.size.height {
                            axes.remove(.vertical)
                        }
                        if newContentSize.width <= geometry.size.width {
                            axes.remove(.horizontal)
                        }
                    }
            }
        }
    }

}

extension ScrollView {

    public func enableScrollIfFullContent() -> some View {
        FillableScrollView(scrollView: self)
    }

}
