import SwiftUI
import Combine

struct OTPModifer: ViewModifier {

    @Binding var pin: String

    var textLimit = 2

    func limitText(_ upper: Int) {
        if pin.count > upper {
            if let lastCharacter = pin.last {
                pin = replace(pin, 1, lastCharacter)
            }

            pin = String(pin.prefix(upper))
        }
    }

    // MARK: - ViewModifier

    func body(content: Content) -> some View {
        VStack {
            content
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .onReceive(Just(pin)) { _ in limitText(textLimit) }
                .frame(width: 50)

            underlineView
        }
    }

    // MARK: - Subviews

    private var underlineView: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.secondary)
            .frame(width: 50)
    }

}
