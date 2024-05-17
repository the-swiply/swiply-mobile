import SwiftUI

struct BiographyOverlay: View {

    let person: CardPerson

    let likeHandler: () -> Void
    let dislikeHandler: () -> Void

    var info: [(Image, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(person.name), \(person.age)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            HStack(spacing: 8) {
                Image(.homeCardIcon)

                Text(person.town)
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
                    dislikeHandler()
                } label: {
                    Image(.dislike)
                }

                Spacer()

                Button {
                    likeHandler()
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
