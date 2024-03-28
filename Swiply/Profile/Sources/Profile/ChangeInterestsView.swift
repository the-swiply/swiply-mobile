import SwiftUI
import SYVisualKit

struct ChangeInterestsView: View {
    var chosenInterests: [String]
    var action: (String) -> Void
    private let interests = ["ios" ,"android" ,"путешествия" ,"велосипед" ,"кулинария" ,"животные" ,"музыка"  ,"Teaтp"  ,"it" ,"суши" ,"книги"  ,"йога" ,"фотография" ,"стендап" ,"ландшафтный дизайн" , "тату", "иностранные языки" ,"танцы" ,"восточные танцы" ,"спорт","пошив одежды", "медитации", "бег" ,"здоровый образ жизни", "пицца"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Выберите увлечения")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.vertical, 12)
            SYFlowView(
                content: interests.map { interest in
                    SYChip(text: interest, isSelected: chosenInterests.contains(interest)) { text in
                        action(text)
                    }
                }
            )
            
            Spacer()
        }
        .padding(24)
    }
}


#Preview {
    ChangeInterestsView(chosenInterests: []) { _ in
        print("lol")
    }
}
