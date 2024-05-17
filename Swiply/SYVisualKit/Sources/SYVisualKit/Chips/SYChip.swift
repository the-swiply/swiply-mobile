import SwiftUI

public struct SYChip: View {
    
    var text: String
    @State private var isSelected = false
    var action: (String) -> Void

    public init(text: String, isSelected: Bool = false, action: @escaping (String) -> Void) {
        self.text = text
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: {
            isSelected.toggle()
            action(text)
        }, label: {
            Text(text)
                .font(.callout)
                .fontWeight(.semibold)
                .padding(.vertical, 8.0)
                .padding(.horizontal, 16.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(lineWidth: 2)
                )
                .foregroundStyle(isSelected ? .pink : .gray)
        })
    }
}

struct SYChip_Preview: PreviewProvider {
    static var previews: some View {
        SYChip(text: "ios", action: { str in
            print(str)
        })
    }
}
