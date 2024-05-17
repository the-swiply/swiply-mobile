import SwiftUI
import SYVisualKit
import CardInformation
import ProfilesService

public struct LikesCardView: View {

    @State var person: Person
    var isBlured: Bool
    var action: () -> Void

    public var body: some View {
        NavigationLink(
            destination: CardInformationView(person: person),
            label: {
                Image(uiImage: person.images.first!!)
                    .centerCropped()
                    .overlay(.ultraThinMaterial)
                    .opacity(isBlured ? 1 : 0)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        )
        .overlay {
            if !isBlured {
                VStack(alignment: .leading) {
                    Spacer()

                    Text(person.name + "," + person.age.description)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.bottom, 8)

                    HStack {
                        Button {
                            action()
                        } label : {
                            Image(.dislike)
                                .resizable()
                                .frame(width: 40, height: 40)
                        }

                        Spacer()

                        Button {
                            action()
                        } label: {
                            Image(.like)
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding(.all, 12)
            }
        }
    }

}
