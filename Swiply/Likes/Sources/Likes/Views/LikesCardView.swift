import SwiftUI
import SYVisualKit

public struct LikesCardView: View {

    let image: Image
    let name: String
    let age: String

    public var body: some View {
        image
            .centerCropped()
            .overlay {
                VStack(alignment: .leading) {
                    Spacer()

                    Text(name + "," + age)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.bottom, 8)

                    HStack {
                        Image(.dislike)
                            .resizable()
                            .frame(width: 40, height: 40)

                        Spacer()

                        Image(.like)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.all, 12)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }

}

#Preview {
    LikesCardView(
        image: Image(.night),
        name: "Night",
        age: "7"
    )
}
