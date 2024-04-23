import SwiftUI

// MARK: - Preference Key

struct ContentSizeKey: PreferenceKey {

    static var defaultValue: CGSize { .zero }

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = CGSize(width: value.width + nextValue().width,
                       height: value.height + nextValue().height)
    }

}

// MARK: - Convenience Modifier

extension View {

    /// Reads the content size of the modified view into the given binding.
    public func contentSize(in size: Binding<CGSize>) -> some View {
        modifier(
            GeometryBasedModifier(
                value: size,
                preferenceKey: ContentSizeKey.self,
                proxyReader: { $0.size }
            )
        )
    }

}
