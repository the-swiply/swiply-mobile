import SwiftUI

public struct SYHeaderView: View {
    
    private let title: String
    private let desription: String
    
    public init(title: String, desription: String = "") {
        self.title = title
        self.desription = desription
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.largeTitle)
                .bold()
            Text(desription)
                .font(.footnote)
                .foregroundStyle(.gray)
        }
        .padding(.top, 23)
    }
}

struct SYHeaderView_Preview: PreviewProvider {
    static var previews: some View {
        SYHeaderView(title: "Интересы", desription: "Добавь в профиль свои интересы, так ты сможешь найти с общими интересами")
    }
}
