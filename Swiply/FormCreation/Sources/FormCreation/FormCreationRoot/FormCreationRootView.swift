import SwiftUI
import ComposableArchitecture

public struct FormCreationRootView: View {

    @Bindable var store: StoreOf<FormCreationRoot>

    public init(store: StoreOf<FormCreationRoot>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            InfoInputView(
                type: .name,
                store: store.scope(state: \.welcome, action: \.welcome)
            )
        } destination: { store in
            switch store.case {
            case let .cityInput(store):
                InfoInputView(
                    type: .town,
                    store: store
                )
            case let .interestsInput(store):
                InterestsView(store: store)
                
            case let .birthdayView(store):
                BirthdayView(
                    store: store
                )
            case let .genderView(store):
                GenderView(
                    store: store
                )
            case let .biographyView(store):
                InfoInputView(
                    type: .info,
                    isMultiLine: true,
                    store: store
                )
            case let .imageView(store):
                ImageView(store: store)
            case let .education(store):
                InfoInputView(
                    type: .education,
                    isOptional: true ,
                    store: store
                )
            case let .work(store):
                InfoInputView(
                    type: .work, 
                    isOptional: true ,
                    store: store
                )
            }
        }
    }
}
