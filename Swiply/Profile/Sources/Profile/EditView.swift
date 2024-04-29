import SwiftUI
import ComposableArchitecture
import UserService


public struct EditFeature: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        var info = Person.tima
        var image: UIImage?
        var isPresented: Bool = false
        var imageIndex: Int = 0
        var isInterest = false
    }
    
    public enum Action: BindableAction, Equatable  {
        case binding(BindingAction<State>)
        case onSaveTap
        case onCancelTap
        case show(Int)
        case changeInterests
        case saveChanges(Person)
        case addInterest(String)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .saveChanges:
                return .run { _ in
                    await self.dismiss()
                }
            case let .show(index):
                state.isPresented = true
                state.imageIndex = index
                return .none
            case .onSaveTap:
                let info = state.info
                return .run { send in
                    await send(.saveChanges(info))
                }
            case .onCancelTap:
                return .run { _ in
                    await self.dismiss()
                }
            case .binding:
                if let image = state.image {
                    state.info.images.append(image)
                    state.image = nil
                }
                return .none
            case .changeInterests:
                state.isInterest = true
                return .none
            case let .addInterest(value):
                state.info.interests.append(value)
                return .none
            }
        }
    }
}

struct EditView: View {
    
    @Bindable var store: StoreOf<EditFeature>
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    Section {
                        HStack {
                            Text("Возраст")
                            Spacer()
                            Text(String(store.info.age))
                                .foregroundStyle(.gray)
                        }
                        
                        HStack {
                            Text("Пол")
                            Spacer()
                            Text(store.info.gender.name)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    Section(header: Text("Данные")) {
                        TextField("Имя", text: $store.info.name)
                        TextField("Город", text: $store.info.town)
                        TextField("Образование", text: $store.info.education, axis: .vertical)
                        TextField("Работа", text: $store.info.work, axis: .vertical)
                        TextField("Описание", text: $store.info.description, axis: .vertical)
                            .lineLimit(1...10)
                       
                       
                        Button(
                            action: {
                                store.send(.changeInterests)
                            },
                            label: {
                                Text("Изменить интересы")
                                    .foregroundStyle(.pink)
                                    
                            }
                        )
                        .sheet(isPresented: $store.isInterest) {
                            ChangeInterestsView(
                                chosenInterests: store.info.interests) { str in
                                    store.send(.addInterest(str))
                                }
                        }
                    }
                    
                    Section(header: Text("Фотографии")) {
                        LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 16), count: 3), spacing: 16) {
                            
                            ForEach((0..<6), id: \.self) { index in
                                ImagePickerView(
                                    image: index < $store.info.images.count ?
                                    $store.info.images[index] : $store.image,
                                    index: index) { index in
                                        store.send(.show(index))
                                    }.sheet(isPresented: $store.isPresented) {
                                        ImagePicker(
                                            image: store.imageIndex < $store.info.images.count ?
                                            $store.info.images[store.imageIndex] : $store.image,
                                            isPresented: $store.isPresented
                                        )
                                    }
                            }
                        }
                    }
                }
                .navigationBarItems(
                    leading:
                        Button(
                            action: {
                                store.send(.onCancelTap)
                            },
                            label: {
                                Text("Отмена")
                                
                            }
                        ), trailing:
                        Button(
                            action: {
                                store.send(.onSaveTap)
                            },
                            label: {
                                Text("Готово")
                                    .bold()
                            }
                        )
                )
                
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationView {
        EditView(
            store: Store(
                initialState: EditFeature.State(),
                reducer: { EditFeature()._printChanges() }
            )
        )
    }
}



public struct ImagePicker: UIViewControllerRepresentable {
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    
    public func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(image: $image, isPresented: $isPresented)
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = self.sourceType
        pickerController.delegate = context.coordinator
        return pickerController
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update here
    }
}

public class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    
    public init(image: Binding<UIImage?>, isPresented: Binding<Bool>) {
        self._image = image
        self._isPresented = isPresented
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = image
        }
        self.isPresented = false
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
}



public struct ImagePickerView: View {
    
    @Binding public var image: UIImage?
    
    //   @Binding public var imageUI: UIImage?
    let index: Int
    let action: (Int) -> Void
    public var body: some View {
        
        
        ZStack(alignment: .bottomTrailing) {
            if let imageProfile = image {
                Image(uiImage: imageProfile)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 136)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16.0)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                
            } else {
                RoundedRectangle(cornerRadius: 16.0)
                    .frame(width: 100, height: 136)
                    .foregroundStyle(.gray.opacity(0.1))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16.0)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            Image(systemName: "plus")
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(.pink)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 2, y: 2)
                .offset(x: 5, y: 5)
                .onTapGesture {
                    action(index)
                }
        }
        
        
    }
}
