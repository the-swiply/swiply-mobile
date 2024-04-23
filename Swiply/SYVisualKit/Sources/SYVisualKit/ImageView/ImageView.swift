import SwiftUI

public struct ImageView: View {

    let image: Image

    public var body: some View {
        image
            .centerCropped()
    }

}

//#Preview {
//    ImageView(image: Image(.card))
//}
