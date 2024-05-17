import SwiftUI
import SYVisualKit

struct ChangeInformationView: View {

    @State var name: String = "Выставка бездомных животных «Надо брать! Летом!»"
    @State var info: String = "Давно собираетесь завести домашнее животное? В начале лета самое время это сделать! Благотворительный фонд «Вирта» проводит выставку бездомных животных, откуда можно будет уйти с новым преданным другом."
    @State var date: Date = Date()

    @State var images: [UIImage?] = [UIImage(resource: .animal), UIImage(resource: .animal2), UIImage(resource: .animal3)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Название мероприятия")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 12)

                SYTextField(
                    placeholder: "Выставка бездомных животных «Надо брать! Летом!»",
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
                    text: $info
                )
                .lineLimit(5...10)

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



                    SYButton(title: "Редактировать") {
                    }
                    .padding(.top, 55)
                    .padding(.bottom, 24)

                    SYButton(title: "Удалить мероприятие") {
                    }
                    .padding(.bottom, 24)

                }
            }
            .padding(.top, 12)

        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 24)
        .navigationTitle("Редактирование Мероприятия")
    }

}
