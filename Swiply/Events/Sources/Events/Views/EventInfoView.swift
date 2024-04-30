import SwiftUI
import SYVisualKit

public struct EventInfoView: View {

    let event: Event

    public init(event: Event) {
        self.event = event
    }

    public var body: some View {
        ScrollView {
            ImageScrollingView(images: event.images, onTapCenter: nil)
                .frame(height: 640)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack {
                VStack {
                    Text(event.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 24)

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
                Spacer()

                Text(
                    event.description
                )
                .font(.title2)
                .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.all, 16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.white)
                    .shadow(radius: 2)
            }
            .padding(.horizontal, 1)
            .padding(.bottom, 24)

        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 24)
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

