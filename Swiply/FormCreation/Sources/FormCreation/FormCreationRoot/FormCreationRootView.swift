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
                title: "Моё имя",
                placeHolder: "Введите имя",
                description: "Ваше имя будет отображаться в профиле Swiply, и у вас будет возможность его изменить",
                store: store.scope(state: \.welcome, action: \.welcome)
            )
        } destination: { store in
            switch store.case {
            case let .cityInput(store):
                InfoInputView(
                    title: "Мой город",
                    placeHolder: "Укажи свой город",
                    description: "Напиши свой город, чтобы знакомиться с людьми, которые живут рядом",
                    store: store
                )
            case let .interestsInput(store):
                InterestsView(store: store)
                
            case let .birthdayView(store):
                BirthdayView(
                    title: "Мой день рождения",
                    description: "Ваш возраст будет указан в профиле",
                    store: store
                )
            case let .genderView(store):
                GenderView(
                    title: "Мой пол",
                    description: "Выберите свой пол",
                    store: store
                )
            case let .biographyView(store):
                InfoInputView(
                    title: "Моя биография",
                    placeHolder: "Напиши немного о себе",
                    description: "Напиши о себе, биография будет отображаться в твоём профиле",
                    isMultiLine: true,
                    store: store
                )
            case let .imageView(store):
                ImageView(store: store)
            case let .education(store):
                InfoInputView(
                    title: "Моё образование", 
                    placeHolder: "Институт, курсы ...",
                    description: "Напиши о своём образование",
                    isOptional: true ,
                    store: store
                )
            case let .work(store):
                InfoInputView(
                    title: "Моя работа",
                    placeHolder: "Название компании, род деятельности ...",
                    description: "Напиши где тв работаешь или чем занимаешься",
                    isOptional: true ,
                    store: store
                )
            }
        }
    }
}
