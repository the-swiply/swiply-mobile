import SwiftUI
import Networking
import SYVisualKit

struct ContentView: View {

    var isDestructive = false
    @State var isFullfilled = false

    @State var text = "0000"

    var body: some View {
//        let _ = Self._printChanges()
        SYOTPTextField(isDestructive: isDestructive, isFullfilled: $isFullfilled, text: $text)

        if isFullfilled {
            SYStrokeButton(title: text, action: { })
        }
    }
}

#Preview {
    ContentView()
}
