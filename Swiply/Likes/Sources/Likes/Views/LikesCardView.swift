import SwiftUI
import SYVisualKit
import CardInformation

public struct LikesCardView: View {

    let image: Image
    let name: String
    let age: String

    public var body: some View {
        NavigationLink(
            destination: CardInformationView(),
            label: {
                image
                    .centerCropped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        )
        .overlay {
            VStack(alignment: .leading) {
                Spacer()

                Text(name + "," + age)
                    .foregroundStyle(.white)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.bottom, 8)

                HStack {
                    Button {

                    } label : {
                        Image(.dislike)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }

                    Spacer()

                    Button {

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

#Preview {
    LikesCardView(
        image: Image(.night),
        name: "Night",
        age: "7"
    )
}
