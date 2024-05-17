import SwiftUI
import SYVisualKit
import ComposableArchitecture
import CardInformation
import ProfilesService

public struct RecommendationsView: View {

    @Bindable var store: StoreOf<Recommendations>

    public init(store: StoreOf<Recommendations>) {
        self.store = store
    }

    // MARK: - View

    public var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    MainBarView(onBack: {
                        store.send(.backButtonTapped)
                    }, onConfirm:  { age, gender in
                        store.send(.filter(age: age, gender: gender))
                    })

                    Spacer()

                    VStack {
                        ZStack {
                            ForEach(store.profiles, id: \.id) { profile in
                                SwipableView(swipeAction: store.state.swipeAction, id: profile.id.uuidString) {
                                    CardView(
                                        person: profile.cardPerson,
                                        likeHandler: { store.send(.likeButtonTapped) },
                                        dislikeHandler: { store.send(.dislikeButtonTapped) },
                                        onTapCenter: { store.send(.onTapCenter) }
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)

                Rectangle()
                    .frame(height: 90)
                    .foregroundStyle(.background)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .onAppear() {
            store.send(.onAppear)
        }
    }

}

private struct MainBarView: View {

    var onBack: (() -> Void)?
    var onConfirm: ((ClosedRange<Int>, ProfileGender) -> Void)?

    @State var isPresented: Bool = false
    @State var sliderPosition: ClosedRange<Int> = 3...8
    @State private var gender: ProfileGender = .any

    var body: some View {
        HStack {
            Button {
                onBack?()
            } label: {
                Image(.backArrow)
            }

            Spacer()


            Image(.mainBarLogo)
                .foregroundStyle(.pink)
                .padding(.vertical, 10)

            Spacer()

            Button(
                action: {
                    isPresented = true
                },
                label: {
                    Image(.filter)
                }
            )
            .sheet(isPresented: $isPresented) {
                VStack {
                    RoundedRectangle(cornerRadius: 100)
                        .frame(width: 64, height: 3)
                        .foregroundStyle(.gray)
                        .brightness(0.3)
                        .padding(.top, 7)
                        .padding(.bottom, 20)

                    HStack {
                        Text("Фильтр")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 24)

                        Spacer()
                    }

                    Picker("", selection: $gender) {
                        Text("Парни").tag(ProfileGender.male)
                        Text("Девушки").tag(ProfileGender.female)
                        Text("Все").tag(ProfileGender.any)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 24)

                    HStack {
                        Text("Возраст")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 8)

                        Spacer()

                        Text("18-26")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }

                    RangedSliderView(value: $sliderPosition, bounds: 1...10)
                        .padding(.bottom, 24)
            

                    SYButton(title: "Применить") {
                        onConfirm?(sliderPosition, gender)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .presentationDetents([.height(400)])
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
