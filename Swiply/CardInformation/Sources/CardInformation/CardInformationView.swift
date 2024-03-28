import SwiftUI
import SYVisualKit

public struct CardInformationView: View {

    var info: [(Image, String)] {
        [(Image(.heart), "Отношения") ,(Image(.ruler), "172") ,(Image(.pets), "Нет") ,(Image(.aquarius), "Водолей") ,(Image(.study), "Высшее")]
    }

    private let interests = ["ios" ,"android" ,"путешествия" ,"велосипед" ,"кулинария" ,"животные" ,"музыка"]

    public init() { }

    public var body: some View {
        ScrollView {
            PhotosView(images: [Image(.girl2), Image(.girl3)])
                .frame(height: 640)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack {
                VStack(alignment: .leading) {
                    Text("Мария, 20")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack(spacing: 8) {
                        Image(.city)

                        Text("Москва")
                    }

                    HStack(spacing: 8) {
                        Image(.planet)

                        Text("5 км")
                    }
                }

                Spacer()
            }

            SYFlowView(
                content: info.map {
                    SYPinkChip(text: $0.1, image: $0.0)
                }
            )
            .frame(minHeight: 110)

            Text(
                "В любой сложной жизненной ситуации остаюсь оптимисткой. \n\nВерю в людей и в то, что встречу здесь достойного человека, которому нужна любовь и поддержка. \n\nМужчине, которого полюблю, отдам всю свою заботу и нежность. Давай знакомиться!"
            )
            .padding(.all, 16)
            .multilineTextAlignment(.leading)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.white)
                    .shadow(radius: 2)
            }

            SYFlowView(
                content: interests.map { interest in
                    SYChip(text: interest) { _ in }
                }
            )
            .frame(minHeight: 150)
            .padding(.all, 1)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 24)
    }

}

struct SYPinkChip: View {

    var text: String
    var image: Image

    init(text: String, image: Image) {
        self.text = text
        self.image = image
    }

    var body: some View {
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
                .foregroundStyle(.pink)
        }
    }

}

#Preview {
    CardInformationView()
}
