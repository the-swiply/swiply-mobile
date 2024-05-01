import SwiftUI

public struct ImageScrollingOverlay: View {

    let maxIndex: Int
    let onTapCenter: (() -> Void)?

    @Binding var currentImageIndex: Int

    public var body: some View {
        HStack(spacing: 0) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    updateImageIndex(isNext: false)
                }

            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    onTapCenter?()
                }

            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    updateImageIndex(isNext: true)
                }
        }
    }

}

extension ImageScrollingOverlay {

    func updateImageIndex(isNext: Bool) {
        if isNext {
            guard currentImageIndex != maxIndex else {
                currentImageIndex = 0
                return
            }

            currentImageIndex += 1
        }
        else {
            guard currentImageIndex != 0 else {
                currentImageIndex = maxIndex
                return
            }

            currentImageIndex -= 1
        }
    }

}

#Preview {
    ImageScrollingOverlay(maxIndex: 2, onTapCenter: nil, currentImageIndex: .constant(0))
}
