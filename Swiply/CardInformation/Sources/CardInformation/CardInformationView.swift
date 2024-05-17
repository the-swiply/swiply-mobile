import SwiftUI
import SYVisualKit
import ProfilesService
import SYCore

public struct CardInformationView: View {



    var person: Profile

    public init(person: Profile) {
        self.person = person
    }

    public var body: some View {
        ScrollView {
            ImageScrollingView(images: person.images.images.map { image in
                switch image {
                case let .image(image):
                    return .image(Image(uiImage: image.image))

                case .loading:
                    return .loading
                }
            }, onTapCenter: nil)
                .frame(height: 435)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack {
                VStack(alignment: .leading) {
                    Text("\(person.name), \(person.age.getAge())")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack(spacing: 8) {
                        Image(.city)

                        Text(person.town)
                    }

//                    HStack(spacing: 8) {
//                        Image(.planet)
//
//                        Text("5 км")
//                    }
                }

                Spacer()
            }

            SYFlowView(
                content: [person.name.count >= 4 ? (Image(.heart), "Отношения") : (Image(.message), "Общение"), (Image(.ruler), "\(person.age.getAge() + 145)") ,(Image(.pets), person.images.images.count <= 1 ? "Нет" : "Да") , person.name.count > 4 ? (Image(.aquarius), "Водолей") : (Image(.gemini), "Близнецы") ,(Image(.study), person.images.images.count > 1 ? "Высшее" : "Колледж")].map {
                    SYPinkChip(text: $0.1, image: $0.0)
                }
            )
            .frame(minHeight: 110)

            Text(
                person.description
            )
            .padding(.all, 16)
            .multilineTextAlignment(.leading)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.white)
                    .shadow(radius: 2)
            }
            .padding(.horizontal, 1)

            SYFlowView(
                content: person.interests.map { interest in
                    SYChip(text: interest.definition) { _ in }
                }
            )
            .frame(minHeight: 150)
            .padding(.all, 1)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 16)
        .navigationTitle("\(person.name), \(person.age.getAge())")
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
                .foregroundStyle(.white)

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

//#Preview {
//    CardInformationView()
//}
