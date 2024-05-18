import SwiftUI

struct GoalsButton: View {

    var style: GoalsButtonModel
    @State var isSelected = false
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 16.0) {
            Image(systemName: style.image)
         
            VStack(alignment: .leading, spacing: 8.0, content: {
                Text(style.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(style.description)
                    .font(.subheadline)
            })
           
        }
        .padding(.all, 16.0)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 2)
        )
        .foregroundStyle(isSelected ? .pink : .gray)
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

struct GoalsButton_Preview: PreviewProvider {
    static var previews: some View {
        GoalsButton(
            style: GoalsButtonModel(
                title: "Отношения",
                image: "heart",
                description: "Найти вторую половинку и создать счастливые отношения"
            )
        )
    }

}

struct GoalsButtonModel {
    let title: String
    let image: String
    let description: String
}
