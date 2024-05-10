import SwiftUI
import ComposableArchitecture
import SYVisualKit
import ProfilesService

public struct ImageFeature: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.inMemory("CreatedProfile")) var profile = CreatedProfile()
        var images: [UIImage?] = Array(repeating: nil, count: 6)
        var isButtonDisabled = true
        var isPresented: Bool = false
        var image: Int = 0
   
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case continueButtonTapped
        case show(Int)

    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .continueButtonTapped:
                state.profile.images = state.images
                return .none
            case .binding:
                state.isButtonDisabled = !(state.images.filter {  $0 != nil }.count >= 1)
                return .none
            case let .show(index):
                state.isPresented = true
                state.image = index
                return .none
            }
        }
    }
}

struct ImageView: View {
    @Bindable var store: StoreOf<ImageFeature>
    var body: some View {
        VStack(alignment: .leading) {
            SYHeaderView(
                title: "Мои фотографии",
                desription: "Добавь не менее одной фотографии, чтобы продолжить"
            )
            .padding(.bottom, 30)
            
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 16), count: 3), spacing: 16, content: {
                ForEach((0..<store.images.count), id: \.self) { index in
                    HStack {
                        ImagePickerView(image: $store.images[index],
                                        index: index) { index in
                            store.send(.show(index))
                        }.sheet(isPresented: $store.isPresented) {
                            ImagePicker(image: $store.images[store.image], isPresented: $store.isPresented)
                        }
                    }
                }
            })
            
    
            
            SYButton(title: "Продолжить") {
                store.send(.continueButtonTapped)
            }
            .disabled(store.isButtonDisabled)
            .padding(.top, 95)
            Spacer()
         
        }
        .padding(.horizontal, 24)
    }
}


#Preview {
    ImageView(store: Store(initialState: ImageFeature.State(), reducer: {
        ImageFeature()
            ._printChanges()
    }))
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
    let index: Int
    let action: (Int) -> Void
    public var body: some View {

    
        ZStack(alignment: .bottomTrailing) {
            if let imageProfile = image {
                Image(uiImage: imageProfile)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16.0)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
          
            } else {
                RoundedRectangle(cornerRadius: 16.0)
                    .frame(width: 110, height: 150)
                    .foregroundStyle(.gray.opacity(0.1))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16.0)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            Button(action: {
                action(index)
            }, label: {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
            })
            .frame(width: 32, height: 32)
            .background(.pink)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 2, y: 2)
            .offset(x: 5, y: 5)
        }
        
    }
}
