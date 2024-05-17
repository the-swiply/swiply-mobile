import SwiftUI
import ComposableArchitecture
import ProfilesService
import SYCore

public struct ProfileFeature: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.inMemory("Person")) var user = Profile()
        var showError = false
        public init() {}
        
//        public init(isError: Bool) {
//            self.showError = isError
//        }
    }
    
    public enum Action: BindableAction, Equatable  {
        case binding(BindingAction<State>)
        case onSettingsTap
        case onEditTap
        case onSubscriptionTap
        case showEdit(Person)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onSettingsTap:
                return .none
            case .onEditTap:
                let user = state.user
                return .run { send in
                    await send(.showEdit(.init(user)))
                }
            case .onSubscriptionTap:
                return .none
            case .showEdit:
                return .none
            case .binding:
                return .none
            }
        }
    }
}

struct ProfileView: View {
    @Bindable var store: StoreOf<ProfileFeature>
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button {
                   
                } label: {
                    Image(.settings).hidden()
                }
                
                Spacer()
                Image(.mainBarLogo)
                    .padding(.top, 10)
                Spacer()
                Button {
                    store.send(.onSettingsTap)
                } label: {
                    Image(.settings)
                }
                
            }

            Spacer()
            ZStack(alignment: .topTrailing) {
                Image(uiImage: store.user.images.getFirstImage())
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
            
            Text( "\(store.user.name), \(store.user.age.getAge())")
                .font(Font.system(size: 28, design: .default))
                .fontWeight(.semibold)
                .padding(.top, 20)
            
            
            Image(.subscription)
                .padding(.top, 20)
                .onTapGesture {
                    store.send(.onSubscriptionTap)
                }
            Spacer()
        }
        .padding(.horizontal, 24)
        .alert("Не удалось обновить данные. Попробуйте позже", isPresented: $store.state.showError) {
            Button("OK", role: .cancel) { }
        }
    }
    
    
  
}

#Preview {
    ProfileView(
        store: Store(
            initialState: ProfileFeature.State(),
            reducer: { ProfileFeature()._printChanges() }
        )
    )
}
