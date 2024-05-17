import SwiftUI
import SYVisualKit

public struct AddEventView: View {

    @State var name: String = ""
    @State var date: Date = Date()

    @State var images: [UIImage?] = Array(repeating: nil, count: 6)

    public init() { }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Название мероприятия")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 12)

                SYTextField(
                    placeholder: "Введите название",
                    footerText: "Используйте до 50 символов",
                    text: $name
                )
                .padding(.bottom, 24)

                Text("Дата")
                    .font(.title)
                    .fontWeight(.bold)

                HStack {
                    DatePicker(
                        selection: $date,
                        displayedComponents: [.date], label: {
                            Text("Выберите дату:")
                        })
                    .environment(\.locale, Locale.init(identifier: "ru"))

                    Spacer()
                }
                .padding(.bottom, 24)


                Text("Описание")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 12)

                SYTextField(
                    placeholder: "Расскажите о мероприятии",
                    footerText: "Используйте до 300 символов",
                    text: $name
                )
                .padding(.bottom, 24)

                VStack(alignment: .leading) {
                    SYHeaderView(
                        title: "Фотографии",
                        desription: "Добавьте фотографии мероприятия"
                    )
                    .padding(.bottom, 30)

                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 16), count: 3), spacing: 16, content: {
                        ForEach((0..<images.count), id: \.self) { index in
                            HStack {
                                ImagePickerView(image: $images[index],
                                                index: index) { index in

                                }
                            }
                        }
                    })



                    SYButton(title: "Создать мероприятие") {
                    }
                    .padding(.top, 55)
                    .padding(.bottom, 24)

                }
            }
            .padding(.top, 12)

        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 24)
        .navigationTitle("Создание Мероприятия")
    }

}

struct ImagePicker: UIViewControllerRepresentable {
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

class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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



struct ImagePickerView: View {

    @Binding public var image: UIImage?
    let index: Int
    let action: (Int) -> Void
    public var body: some View {


        ZStack(alignment: .bottomTrailing) {
            if let imageProfile = image {
                Image(uiImage: imageProfile)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 88, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0))
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 16.0)
//                            .stroke(.gray.opacity(0.5), lineWidth: 2)
//                    }

            } else {
                RoundedRectangle(cornerRadius: 16.0)
                    .frame(width: 88, height: 120)
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
