import SwiftUI
import SYVisualKit
import UserService

public struct CardInformationView: View {

    var info: [(Image, String)] {
        [(Image(.heart), "Отношения") ,(Image(.ruler), "172") ,(Image(.pets), "Нет") ,(Image(.aquarius), "Водолей") ,(Image(.study), "Высшее")]
    }

    var person: Person

    public init(person: Person) {
        self.person = person
    }

    public var body: some View {
        ScrollView {
            PhotosView(images: person.images.map { Image(uiImage: $0!) })
                .frame(height: 640)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack {
                VStack(alignment: .leading) {
                    Text("\(person.name), \(person.age.description)")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack(spacing: 8) {
                        Image(.city)

                        Text(person.town)
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
                    SYChip(text: interest) { _ in }
                }
            )
            .frame(minHeight: 150)
            .padding(.all, 1)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 24)
        .navigationTitle("\(person.name), \(person.age)")
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

//#Preview {
//    CardInformationView()
//}
