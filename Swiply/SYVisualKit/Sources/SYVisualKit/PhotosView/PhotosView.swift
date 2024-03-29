import SwiftUI

public struct PhotosView: View {

    var images: [Image]
    @State private var currentIndex: Int = 0

    public init(images: [Image]) {
        self.images = images
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                images[currentIndex]
                    .centerCropped()
                    .id(currentIndex)
                    .transition(.slide)
                    .onTapGesture { location in
                        let isRightSide = location.x > geometry.size.width / 2

                        if isRightSide {
                            withAnimation {
                                currentIndex = currentIndex < images.count - 1 ? currentIndex + 1 : 0
                            }
                        } else {
                            withAnimation {
                                currentIndex = currentIndex > 0 ? currentIndex - 1 : images.count - 1
                            }
                        }
                    }

                VStack {
                    HStack(spacing: 8) {
                        ForEach((0..<images.count), id: \.self) { index in
                            let spacing: CGFloat = CGFloat(8 * (images.count - 1)) + 24 * 2
                            let leftPart = geometry.size.width - spacing
                            let width = leftPart / CGFloat(images.count)

                            if images.count > 1 {
                                RoundedRectangle(cornerRadius: 1.5)
                                    .foregroundStyle(index == currentIndex ? .white : .gray.opacity(0.3))
                                    .frame(width: width, height: 3)
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)
            }
        }
    }
}
