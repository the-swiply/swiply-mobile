import SwiftUI
import SYVisualKit

public struct EventInfoView: View {

    let event: Event

    public init(event: Event) {
        self.event = event
    }

    public var body: some View {
        ScrollView {
            ImageScrollingView(images: event.images.map { Image(uiImage: $0) }, onTapCenter: nil)
                .frame(height: 435)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(event.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 24)

                        Spacer()
                    }

                    HStack {
                        Image(.date)
                            .foregroundStyle(.pink)
                            .padding(.trailing, 12)

                        Text("24 Мая 2024")
                            .font(.subheadline)
                            .fontWeight(.bold)

                        Spacer()
                    }
                    .padding(.bottom, 14)

                    HStack {
                        Text("Описание")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(alignment: .leading)

                        Spacer()
                    }
                }

                Spacer()
            }

            HStack {
                Text(
                    event.description
                )
                .font(.subheadline)
                .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.top, 2)
            .padding(.bottom, 35)

            SYButton(title: "Я хочу посетить") {

            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
        .navigationTitle("Информация")
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

