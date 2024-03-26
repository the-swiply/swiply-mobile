import SwiftUI

public struct SYBlurChip: View {

    var text: String
    var image: Image

    public init(text: String, image: Image) {
        self.text = text
        self.image = image
    }

    public var body: some View {
        HStack(spacing: 8) {
            image

            Text(text)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
        .padding(.vertical, 8.0)
        .padding(.horizontal, 10.0)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.ultraThinMaterial)
                .brightness(-0.4)
        }
    }

}

#Preview {
    SYBlurChip(text: "отношения", image: .init(systemName: "heart.fill"))
}
