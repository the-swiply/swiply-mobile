import SwiftUI

// MARK: - Preference Key

struct ContentFrameKey: PreferenceKey {

    static let defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = value.union(nextValue())
    }

}

// MARK: - Convenience Modifier

extension View {

    /// Reads the frame of the modified view into the given binding.
    public func contentFrame(
        in frame: Binding<CGRect>,
        coordinateSpace: CoordinateSpace = .global
    ) -> some View {

        modifier(
            GeometryBasedModifier(
                value: frame,
                preferenceKey: ContentFrameKey.self,
                proxyReader: { $0.frame(in: coordinateSpace) }
            )
        )
    }

}
