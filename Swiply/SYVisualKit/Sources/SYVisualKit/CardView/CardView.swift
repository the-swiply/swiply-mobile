import SwiftUI

public struct CardView: View {

    var info: [(Image, String)] {
        [(Image(.heart), "Отношения") ,(Image(.ruler), "172") ,(Image(.pets), "Нет") ,(Image(.aquarius), "Водолей") ,(Image(.study), "Высшее")]
    }

    @State var flowSize: CGSize = .zero

    var index: Int
    var tagId: UUID
    var images: [Image] = []

    public init(index: Int, tagId: UUID = UUID(), images: [Image]) {
        self.index = index
        self.tagId = tagId
        self.images = images
    }

    public var body: some View {
        ZStack {
            PhotosView(images: images)
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Мария, 20")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        HStack(spacing: 8) {
                            Image(.homeCardIcon)

                            Text("Москва")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom, 12)

                        SYFlowView(
                            content: info.map {
                                SYBlurChip(text: $0.1, image: $0.0)
                            }
                        )

                        HStack {
                            Button {

                            } label: {
                                Image(.dislike)
                            }

                            Spacer()

                            Button {

                            } label: {
                                Image(.like)
                            }
                        }
                        .padding(.top, 16)
                    }
                    .padding(.bottom, 35)
                    .padding(.horizontal, 16)
                }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

}
