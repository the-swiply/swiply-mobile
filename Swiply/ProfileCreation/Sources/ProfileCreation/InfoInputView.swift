import SwiftUI
import ComposableArchitecture
import SYVisualKit
import ProfilesService

public struct InfoInputFeature: Reducer {

    @ObservableState
    public struct State: Equatable {
        @Shared(.inMemory("CreatedProfile")) var profile = CreatedProfile()
        @Shared(.appStorage("Email")) var email = ""
        var userInfo = ""
        var isButtonDisabled = true
        public init() { }
    }
    
    public enum Action: BindableAction, Equatable  {
        case binding(BindingAction<State>)
        case changeButtonState
        case continueButtonTapped(Types)
        case delegate(Delegate)

        @CasePathable
        public enum Delegate: Equatable {
            case finishProfile(CreatedProfile)
        }
     }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .run { send in
                    await send(.changeButtonState)
                }
            case .changeButtonState:
                state.isButtonDisabled = state.userInfo.isEmpty
                return .none
            case let .continueButtonTapped(type):
                switch type {
                case .name:
                    state.profile.name = state.userInfo
                case .town:
                    state.profile.town = state.userInfo
                case .info:
                    state.profile.description = state.userInfo
                case .education:
                    state.profile.education = state.userInfo
                case .work:
                    state.profile.work = state.userInfo
                }
                
                if type == .work {
                    state.profile.email = state.email
                    return .run { [state] send in
                        await send(.delegate(.finishProfile(state.profile)))
                    }
                } else {
                    return .none
                }
                
            case .delegate:
                return .none
            }
        }
    }
}

struct InfoInputView: View {
    
    var type: Types
    var isOptional: Bool = false
    var isMultiLine: Bool = false
    
    @Bindable var store: StoreOf<InfoInputFeature>
    
    
    var body: some View {
            VStack(alignment: .leading) {
                SYHeaderView(
                    title: type.title
                )
                SYTextField(
                    placeholder: type.placeHolder,
                    footerText: type.description,
                    text: $store.userInfo,
                    isMultiLine: isMultiLine
                )
                .padding(.top, 80)
                
                HStack {
                    SYButton(title: "Продолжить") {
                        store.send(.continueButtonTapped(type))
                    }
                    .disabled(store.isButtonDisabled)
                    .padding(.top, 95)
                    
                    if isOptional {
                        Button {
                            store.send(.continueButtonTapped(type))
                        } label : {
                            Text("Пропустить")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.white)
                                .padding(.vertical, 9)
                                .frame(maxWidth: .infinity)
                            
                        }
                        .tint(.gray.opacity(0.4))
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 16))
                        .padding(.top, 95)
                    }
                }
                Spacer()
                
            }
            .padding(.horizontal, 24)
        }
}


#Preview {
    @Bindable var kii = Store(initialState: InfoInputFeature.State(), reducer: {
        InfoInputFeature()._printChanges()
    })
    
    return InfoInputView(
        type: .name,
        store: Store(initialState: InfoInputFeature.State(), reducer: {
            InfoInputFeature()._printChanges()
        })
    )
}
