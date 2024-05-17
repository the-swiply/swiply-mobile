import SwiftUI
import SYVisualKit
import SYCore
struct ChangeInterestsView: View {
    var chosenInterests: [Interest]
    var interests: [Interest]
    var action: (Interest) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Выберите увлечения")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.vertical, 12)
            SYFlowView(
                content: interests.map { interest in
                    SYChip(text: interest.definition, isSelected: chosenInterests.contains(interest)) { text in
                        if let interest = interests.first(where: { $0.definition == text}) {
                            action(interest)
                        }
                    }
                }
            )
            
            Spacer()
        }
        .padding(24)
    }
}
