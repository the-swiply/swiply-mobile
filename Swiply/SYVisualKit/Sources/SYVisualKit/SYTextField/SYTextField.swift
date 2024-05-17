import SwiftUI

public struct SYTextField: View {

    // MARK: - Private Properties

    private let placeholder: String
    private let footerText: String?

    @Binding private var text: String

    // MARK: - View

    public var body: some View {
        VStack(alignment: .leading) {
            textField
            underlineView
            footer
        }
    }

    // MARK: - Init

    public init(placeholder: String, footerText: String?, text: Binding<String>) {
        self.placeholder = placeholder
        self.footerText = footerText
        self._text = text
    }

    //MARK: - Subviews

    private var textField: some View {
        TextField(placeholder, text: $text, axis: .vertical)
            .font(.title3)
    }

    private var underlineView: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.black)
    }

    @ViewBuilder
    private var footer: some View {
        if let footerText {
            Text(footerText)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 20)
        }
    }

}
