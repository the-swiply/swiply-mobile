import SwiftUI

public struct SYButton: View {

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
                .foregroundStyle(.white)
                .padding(.vertical, 9)
                .frame(maxWidth: .infinity)
            
        }
        .tint(.pink)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 16))
    }
    
}
