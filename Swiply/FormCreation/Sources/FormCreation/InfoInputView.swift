import SwiftUI
import ComposableArchitecture
import SYVisualKit

public struct InfoInputReducer: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        var userInfo = ""
        var isButtonDisabled = true
        public init() { }
    }
    
    public enum Action: BindableAction, Sendable, Equatable  {
        case binding(BindingAction<State>)
        case changeButtonState
        case continueButtonTapped
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
            case .continueButtonTapped:
                return .none
                
            }
        }
    }
}

struct InfoInputView: View {
    
    var title: String
    var placeHolder: String
    var description: String
    var isOptional: Bool = false
    var isMultiLine: Bool = false
    
    @Bindable var store: StoreOf<InfoInputReducer>
    
    
    var body: some View {
            VStack(alignment: .leading) {
                SYHeaderView(
                    title: title
                )
                SYTextField(
                    placeholder: placeHolder,
                    footerText: description,
                    text: $store.userInfo,
                    isMultiLine: isMultiLine
                )
                .padding(.top, 80)
                
                HStack {
                    SYButton(title: "Продолжить") {
                        store.send(.continueButtonTapped)
                    }
                    .disabled(store.isButtonDisabled)
                    .padding(.top, 95)
                    
                    if isOptional {
                        Button {
                            store.send(.continueButtonTapped)
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
    @Bindable var kii = Store(initialState: InfoInputReducer.State(), reducer: {
        InfoInputReducer()._printChanges()
    })
    
    return InfoInputView(
        title: "Моё имя",
        placeHolder: "Введите имя",
        description: "Ваше имя будет отображаться в профиле Swiply, и у вас будет возможность его изменить",
        store: Store(initialState: InfoInputReducer.State(), reducer: {
            InfoInputReducer()._printChanges()
        })
    )
}
