import SwiftUI

struct CurrentImageIndicatorView: View {

    let currentImageIndex: Int
    let imageCount: Int
    let parentSize: CGSize

    var body: some View {
        HStack {
            ForEach(0 ..< imageCount, id: \.self) { index in
                Capsule()
                    .foregroundStyle(currentImageIndex == index ? .white : .gray.opacity(0.3))
                    .frame(width: imageIndicatorWidth, height: 4)
            }
        }
    }

}

private extension CurrentImageIndicatorView {

    var imageIndicatorWidth: CGFloat {
        abs(round(parentSize.width / CGFloat(imageCount) - 28))
    }

}

#Preview {
    CurrentImageIndicatorView(
        currentImageIndex: 0,
        imageCount: 3,
        parentSize: .init(width: 300, height: 300)
    )
}
