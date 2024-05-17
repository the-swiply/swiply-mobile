import SwiftUI
import ComposableArchitecture
import SYVisualKit

public struct EventsView: View {
    
    @State var events: [Event] = [
        .init(id: UUID(),
            name: "Выставка-реконструкция «Терракотовая армия. Бессмертные воины Китая»",
              description: "Реконструкция сенсационной археологической находки XX века — многотысячного глиняного войска китайского императора Цинь Шихуанди, правившего в III веке до н. э., — не оставит равнодушным ни одного зрителя. Посетители выставки на ВДНХ перенесутся в мистическую атмосферу Древнего Китая и ощутят реальный масштаб грандиозной армии.", date: Date(),
              images: [UIImage(resource: .army), UIImage(resource: .army2)]
             ),
        .init(id: UUID(), name: "Выставка бездомных животных «Надо брать! Летом!»",
              description: "Давно собираетесь завести домашнее животное? В начале лета самое время это сделать! Благотворительный фонд «Вирта» проводит выставку бездомных животных, откуда можно будет уйти с новым преданным другом.",
              date: Date(),
              images: [UIImage(resource: .animal), UIImage(resource: .animal2), UIImage(resource: .animal3)]),
        .init(id: UUID(), name: "Выставка «Сальвадор Дали & Пабло Пикассо»",
              description: "Добро пожаловать в мир сюрреализма! На выставке в Путевом дворце Василия III вы увидите подлинные работы Дали и Пикассо, узнаете о творческом пути великих художников и откроете для себя новые грани искусства.", date: Date(),
              images: [UIImage(resource: .picasso)]),
        .init(id: UUID(), name: "Выступление Елены Блиновской",
              description: "Марафон желаний Елены Блиновской облетел уже весь мир, а теперь собрался и до СИЗО!", date: Date(),
              images: [UIImage(resource: .blin)])
    ]

    @State var category: Int = 0
    @State var isPresented: Bool = false

    @State var showDatePicker: Bool = false
    @State var savedDate: Date? = nil

    public init() { }
    
    public var body: some View {
        VStack {
            Picker("", selection: $category) {
                Text("Все").tag(0)
                Text("Избранное").tag(1)
                Text("Мои").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 24)
            .padding(.horizontal, 24)

            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    if !events.isEmpty {
                        ForEach(Array(stride(from: 0, to: events.count - 1, by: 2)), id: \.self) { index in
                            if events.indices.contains(index + 1) {

                                row(firstEvent: events[index], secondEvent: events[index + 1])
                                    .padding(.vertical, 5)

                            }
                        }
                    }

                    if events.count % 2 != 0 {
                        row(firstEvent: events[events.count - 1])
                    }
                }
                .padding(.horizontal, 24)

//                SYButton(title: "+") {
//
//                }

                Button {

                } label : {
                    RoundedRectangle(cornerRadius: 32)
                        .frame(width: 64, height: 64, alignment: .bottom)
                        .foregroundStyle(.pink)
                        .overlay {
                            HStack {
                                Spacer()

                                VStack {
                                    Spacer()

                                    Image(systemName: "plus")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 32))
//                                    Text("+")
//                                        .font(.largeTitle)
//                                        .fontWeight(.bold)
//                                        .foregroundStyle(.white)
//                                        .multilineTextAlignment(.center)

                                    Spacer()
                                }

                                Spacer()
                            }
                        }
                        .opacity(showDatePicker ? 0 : 1)
                        .padding(.bottom, 24)
                        .padding(.trailing, 44)
                }

//                if showDatePicker {
//                    VStack {
//                        Spacer()
//
//                        DatePickerWithButtons(showDatePicker: $showDatePicker, savedDate: $savedDate, selectedDate: savedDate ?? Date())
//                            .animation(.linear)
//                            .transition(.opacity)
//                            .padding(.bottom, 24)
//                            .padding(.horizontal, 24)
//
//                    }
//                }

            }
        }
        .padding(.top, 12)
        .scrollIndicators(.hidden)
        .navigationTitle("Events")
        .toolbar(content: {
                    Button(action: {
                        isPresented = true
                    }, label: {
                        Image(.date)
                            .foregroundStyle(.pink)

                    })
                    .sheet(isPresented: $isPresented) {
                        VStack {
                            RoundedRectangle(cornerRadius: 100)
                                .frame(width: 64, height: 3)
                                .foregroundStyle(.gray)
                                .brightness(0.3)
                                .padding(.top, 7)
                                .padding(.bottom, 20)

                            HStack {
                                Text("Выберите дату")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 24)

                                Spacer()
                            }
                            .padding(.bottom, 24)

                            DatePickerWithButtons(showDatePicker: $showDatePicker, savedDate: $savedDate, selectedDate: savedDate ?? Date())
                                .animation(.linear)
                                .transition(.opacity)

                        }
                        .padding(.horizontal, 24)
                    }
                    .presentationDetents([.height(600)])
                })
        .onAppear() {
            
        }
    }

    

    @ViewBuilder
    private func row(firstEvent: Event, secondEvent: Event? = nil) -> some View {
        if let secondEvent {
            HStack(alignment: .top, spacing: 12) {
                Spacer()
                
                VStack(alignment: .leading) {
                    NavigationLink(
//                        destination: EventInfoView(event: firstEvent),
                                   destination: ChangeInformation(),
                        label: {
                            ImageScrollingView(images: [.image(Image(uiImage: firstEvent.images.first!))], onTapCenter: nil)
                                .frame(width: 156, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    )
                    
                    HStack {
                        Text(firstEvent.name)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .frame(maxWidth: 156, alignment: .leading)
                        
                        
                        Spacer()
                    }
                }
                
                VStack(alignment: .leading)  {
                    NavigationLink(
                        destination: EventInfoView(event: secondEvent),
                        label: {
                            ImageScrollingView(images: [.image(Image(uiImage: secondEvent.images.first!))], onTapCenter: nil)
                                .frame(width: 156, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    )
                    HStack {
                        Text(secondEvent.name)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .frame(maxWidth: 156, alignment: .leading)
                        
                        Spacer()
                    }
                }
                
                Spacer()
            }
        }
        else {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading) {
                    NavigationLink(
                        destination: EventInfoView(event: firstEvent),
                        label: {
                            ImageScrollingView(images: [.image(Image(uiImage: firstEvent.images.first!))], onTapCenter: nil)
                                .frame(width: 156, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    )
                    
                    HStack {
                        Text(firstEvent.name)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .frame(width: 156)
                        
                        Spacer()
                    }
                }
                
                VStack {
                    ImageScrollingView(images: firstEvent.images.map { .image(Image(uiImage: $0)) }, onTapCenter: nil)
                        .frame(width: 156, height: 200)

                    HStack {
                        Text(firstEvent.name)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .frame(width: 156)
                        
                        Spacer()
                    }
                }
                .opacity(0)
            }
        }
    }
    
}

struct FirstView: View {

    @State var showDatePicker: Bool = false
    @State var savedDate: Date? = nil

    var body: some View {
        ZStack {
            HStack {
                Text("Selected date: ")
                Button(action: {
                    showDatePicker.toggle()
                }, label: {
                    Text(savedDate?.description ?? "SELECT DATE")
                })
            }


            if showDatePicker {
                DatePickerWithButtons(showDatePicker: $showDatePicker, savedDate: $savedDate, selectedDate: savedDate ?? Date())
                    .animation(.linear)
                    .transition(.opacity)
            }
        }

    }
}

struct DatePickerWithButtons: View {

    @Binding var showDatePicker: Bool
    @Binding var savedDate: Date?
    @State var selectedDate: Date = Date()

    var body: some View {
        ZStack(alignment: .bottom) {

//            Color.black.opacity(0.3)
//                .edgesIgnoringSafeArea(.all)


            VStack {
                DatePicker("Test", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())

                Divider()
                    .padding(.bottom, 12)

                HStack {

                    Button(action: {
                        showDatePicker = false
                    }, label: {
                        Text("Cancel")
                    })

                    Spacer()

                    Button(action: {
                        savedDate = selectedDate
                        showDatePicker = false
                    }, label: {
                        Text("Save")
                            .bold()
                    })

                }
                .padding(.horizontal)

            }
            .padding()
            .background(
                Color.white
                    .cornerRadius(30)
            )
            .padding(.bottom, 24)


        }

    }
}

#Preview {
    EventsView()
}
