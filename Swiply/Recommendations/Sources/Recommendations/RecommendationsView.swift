import SwiftUI
import SYVisualKit
import ComposableArchitecture
import CardInformation
import UserService

public struct RecommendationsView: View {

//    @Bindable var store: StoreOf<Recommendations>

    @State private var data: [Person] =
    [
        UserService.Person.ann,
        UserService.Person.daria,
        UserService.Person.kate,
        UserService.Person.maria,
        UserService.Person.vera,
    ]

    @State var cards: [CardView] = [
        CardView(index: 0, images: [Image(.night), Image(.card)], navigateTo: { CardInformationView(person: UserService.Person.ann) }),
        CardView(index: 1, images: [Image(.night), Image(.card)], navigateTo: { CardInformationView(person: UserService.Person.daria) }),
        CardView(index: 2, images: [Image(.night), Image(.card)], navigateTo: { CardInformationView(person: UserService.Person.kate) }),
        CardView(index: 3, images: [Image(.night), Image(.card)], navigateTo: { CardInformationView(person: UserService.Person.maria) }),
        CardView(index: 4, images: [Image(.night), Image(.card)], navigateTo: { CardInformationView(person: UserService.Person.vera) })
    ]

    public init() { }

    // MARK: - View

    public var body: some View {
        NavigationStack {
            VStack {
                MainBarView(onBack: {}, onOptions: {})
                
                Spacer()
                
                CardSwiperView(cards: self.$cards , onCardSwiped: { swipeDirection, index in
                    
                    switch swipeDirection {
                    case .left:
                        print("Card swiped Left direction at index \(index)")
                    case .right:
                        print("Card swiped Right direction at index \(index)")
                    case .top:
                        print("Card swiped Top direction at index \(index)")
                    case .bottom:
                        print("Card swiped Bottom direction at index \(index)")
                    }
                }, onCardDragged: { swipeDirection, index, offset in
                    print("Card dragged \(swipeDirection) direction at index \(index) with offset \(offset)")
                })
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }

}

private struct MainBarView: View {

    var onBack: (() -> Void)?
    var onOptions: (() -> Void)?

    var body: some View {
        HStack {
            Button {
                onBack?()
            } label: {
                Image(.backArrow)
            }

            Spacer()


            Image(.mainBarLogo)
                .padding(.vertical, 10)

            Spacer()

            Button {
                onOptions?()
            } label: {
                Image(.filter)
            }
        }
    }

}


//#Preview {
//    RecommendationsView(
//        store: Store(initialState: Recommendations.State()) {
//            Recommendations()
//        }
//    )
//}
