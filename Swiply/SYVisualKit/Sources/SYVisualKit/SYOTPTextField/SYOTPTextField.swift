import SwiftUI
import Combine

public struct SYOTPTextField: View {

    // MARK: - Private Types

    private enum FocusCell {
        case one
        case two
        case three
        case four
    }

    // MARK: - Internal Properties

    let isDestructive: Bool
    @Binding var isFullfilled: Bool
    @Binding var text: String

    // MARK: - Private Properties

    @FocusState private var focusCellState: FocusCell?

    @State private var cellOne: String = ""
    @State private var cellTwo: String = ""
    @State private var cellThree: String = ""
    @State private var cellFour: String = ""

    // MARK: - Init

    public init(isDestructive: Bool, isFullfilled: Binding<Bool>, text: Binding<String>) {
        self.isDestructive = isDestructive
        self._isFullfilled = isFullfilled
        self._text = text
    }

    //MARK: - Protocol View

    public var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 24) {
                TextField("", text: $cellOne)
                    .font(.title3)
                    .modifier(OTPModifer(pin: $cellOne))
                    .onChange(of: cellOne) { _, newValue in
                        if newValue.count == 2 {
                            let index = newValue.index(newValue.startIndex, offsetBy: 1)

                            text = replace(text, 0, newValue[index])

                            focusCellState = .two
                        }
                        if newValue.count == 1 && !newValue.hasPrefix("\u{200B}") {
                            cellOne = "\u{200B}" + newValue
                        }

                        changeFullfillStateIfNeeded()
                    }
                    .focused($focusCellState, equals: .one)

                TextField("", text: $cellTwo)
                    .font(.title3)
                    .modifier(OTPModifer(pin: $cellTwo))
                    .onChange(of: cellTwo) { _, newValue in
                        if newValue.count == 2 {
                            let index = newValue.index(newValue.startIndex, offsetBy: 1)
                            text = replace(text, 1, newValue[index])

                            focusCellState = .three
                        }
                        if newValue.count == 1 && !newValue.hasPrefix("\u{200B}") {
                            cellTwo = "\u{200B}" + newValue
                        }
                        else if newValue.count == 0 {
                            focusCellState = .one
                            cellTwo = "\u{200B}"
                        }

                        changeFullfillStateIfNeeded()
                    }
                    .focused($focusCellState, equals: .two)

                TextField("", text: $cellThree)
                    .font(.title3)
                    .modifier(OTPModifer(pin: $cellThree))
                    .onChange(of: cellThree) { _, newValue in
                        if newValue.count == 2 {
                            let index = newValue.index(newValue.startIndex, offsetBy: 1)
                            text = replace(text, 2, newValue[index])

                            focusCellState = .four
                        }
                        if newValue.count == 1 && !newValue.hasPrefix("\u{200B}") {
                            cellThree = "\u{200B}" + newValue
                        }
                        else if newValue.count == 0 {
                            focusCellState = .two
                            cellThree = "\u{200B}"
                        }

                        changeFullfillStateIfNeeded()
                    }
                    .focused($focusCellState, equals: .three)

                TextField("", text: $cellFour)
                    .font(.title3)
                    .modifier(OTPModifer(pin: $cellFour))
                    .onChange(of: cellFour) { _, newValue in
                        if newValue.count == 2 {
                            let index = newValue.index(newValue.startIndex, offsetBy: 1)
                            text = replace(text, 3, newValue[index])
                        }
                        if newValue.count == 1 && !newValue.hasPrefix("\u{200B}") {
                            cellFour = "\u{200B}" + newValue
                        }
                        if newValue.count == 0 {
                            focusCellState = .three
                            cellFour = "\u{200B}"
                        }

                        changeFullfillStateIfNeeded()
                    }
                    .focused($focusCellState, equals: .four)
            }

            Text("Неверный код. Попробуйте снова.")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.red)
                .opacity(isDestructive ? 1 : 0)

        }
        .onAppear {
            focusCellState = .one
        }
    }

    // MARK: - Private Methods

    private func changeFullfillStateIfNeeded() {
        isFullfilled =
        cellOne.count == 2 &&
        cellTwo.count == 2 &&
        cellThree.count == 2 &&
        cellFour.count == 2
    }

}

struct Preview: PreviewProvider {

    @State var isDestructive = false
    @State var isFullfilled = false
    @State var text = "0000"

    static var previews: some View {
        SYOTPTextField(
            isDestructive: true,
            isFullfilled: .constant(true),
            text: .constant("2222")
        )
    }

}
