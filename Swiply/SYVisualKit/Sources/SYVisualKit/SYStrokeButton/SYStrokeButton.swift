import SwiftUI

public struct SYStrokeButton: View {

    // MARK: - Private Properties

    private let title: String
    private let action: () -> Void

    // MARK: - Init

    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    // MARK: - View
    
    public var body: some View {
        Button {
            action()
        } label : {
            Text(title)
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
