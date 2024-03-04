import SwiftUI

public struct EmailInputView: View {

    @State private var text: String = ""

    // MARK: - View

    public var body: some View {
        textField
    }

    public init() { }

    //MARK: - Subviews

    private var textField: some View {
        VStack(spacing: 95) {
            SYTextField(footerText: "Мы отправим текстовое сообщение с кодом подтверждения", text: $text)

            SYStrokeButton {

            }
            .tint(.black)
            .padding(.horizontal, 24)

            SYButton {

            }
            .padding(.horizontal, 24)
        }
    }

}

struct SYButton: View {

    // MARK: - Internal Properties

    var action: () -> Void

    // MARK: - View

    var body: some View {
        Button {
            action()
        } label : {
            Text("Продолжить")
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .padding(.vertical, 9)
                .frame(maxWidth: .infinity)

        }
        .tint(.pink)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 16))
    }

}

struct SYStrokeButton: View {

    // MARK: - Internal Properties

    var action: () -> Void

    // MARK: - View

    var body: some View {
        Button {
            action()
        } label : {
            Text("Продолжить")
                .font(.title3)
                .bold()
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(lineWidth: 2)
                )
        }
    }

}

struct SYTextField: View {

    let footerText: String?

    @Binding var text: String

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading) {
            textField
            underlineView
            footer
        }
    }

    //MARK: - Subviews

    private var textField: some View {
        TextField("Email", text: $text)
            .font(.title3)
            .padding(.horizontal, 24)
    }

    private var underlineView: some View {
        Rectangle().frame(height: 1)
            .foregroundColor(.black)
            .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var footer: some View {
        if let footerText {
            Text(footerText)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 24)
                .padding(.top, 20)
        }
    }

}


#Preview {
    EmailInputView()
}
