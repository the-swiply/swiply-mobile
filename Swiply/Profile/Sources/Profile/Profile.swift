import SwiftUI
import ComposableArchitecture
import UserService

public struct ProfileFeature: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        var user = Person.jungkook
        public init() {}
    }
    
    public enum Action: Equatable  {
        case onSettingsTap
        case onEditTap
        case onSubscriptionTap
        case showEdit(Person)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onSettingsTap:
                return .none
            case .onEditTap:
                let user = state.user
                return .run { send in
                    await send(.showEdit(user))
                }
            case .onSubscriptionTap:
                return .none
            case .showEdit:
                return .none
            }
        }
    }
}

struct Profile: View {
    @Bindable var store: StoreOf<ProfileFeature>
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                Image(.mainBarLogo)
                
                Spacer()
                Button {
                    store.send(.onSettingsTap)
                } label: {
                    Image(.settings)
                }
                
            }
            
            ZStack(alignment: .topTrailing) {
                Image(uiImage: store.user.images.first!!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 155, height: 155)
                    .clipShape(Circle())
                    .padding(9)
                    .overlay(Circle().stroke(.pink.opacity(0.6), lineWidth: 4))
                ZStack {
                    Circle()
                        .stroke(.gray.opacity(0.4), lineWidth: 5)
                        .frame(width: 48, height: 48)
                    
                        .foregroundStyle(.white)
                        .background(.white)
                        .clipShape(Circle())
                    Button(action: {
                        store.send(.onEditTap)
                    }, label: {
                            Image(systemName: "applepencil.gen1")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .foregroundStyle(.gray)
                    })
                }
                .offset(y: 9)
            }
            .padding(.top, 35)
            
            Text( "\(store.user.name), \(store.user.age)")
                .font(Font.system(size: 28, design: .default))
                .fontWeight(.semibold)
                .padding(.top, 20)
            
            
            Image(.subscription)
                .padding(.top, 20)
                .onTapGesture {
                    store.send(.onSubscriptionTap)
                }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    Profile(
        store: Store(
            initialState: ProfileFeature.State(),
            reducer: { ProfileFeature()._printChanges() }
        )
    )
}
