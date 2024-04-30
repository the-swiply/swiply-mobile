import SwiftUI
import ComposableArchitecture
import SYVisualKit

public struct Event {
    let name: String
    let description: String
    let images: [Image]
}

public struct EventsView: View {
    
    @State var events: [Event] = [
        .init(name: "Выставка-реконструкция «Терракотовая армия. Бессмертные воины Китая»", 
              description: "Реконструкция сенсационной археологической находки XX века — многотысячного глиняного войска китайского императора Цинь Шихуанди, правившего в III веке до н. э., — не оставит равнодушным ни одного зрителя. Посетители выставки на ВДНХ перенесутся в мистическую атмосферу Древнего Китая и ощутят реальный масштаб грандиозной армии.",
              images: [Image(.army), Image(.army2)]
             ),
        .init(name: "Выставка бездомных животных «Надо брать! Летом!»",
              description: "Давно собираетесь завести домашнее животное? В начале лета самое время это сделать! Благотворительный фонд «Вирта» проводит выставку бездомных животных, откуда можно будет уйти с новым преданным другом.",
              images: [Image(.animal), Image(.animal2), Image(.animal3)]),
        .init(name: "Выставка «Сальвадор Дали & Пабло Пикассо»",
              description: "Добро пожаловать в мир сюрреализма! На выставке в Путевом дворце Василия III вы увидите подлинные работы Дали и Пикассо, узнаете о творческом пути великих художников и откроете для себя новые грани искусства.",
              images: [Image(.picasso)]),
        .init(name: "Выступление Елены Блиновской",
              description: "Марафон желаний Елены Блиновской облетел уже весь мир, а теперь собрался и до СИЗО!",
              images: [Image(.blin)])
    ]
    
    public init() { }
    
    public var body: some View {
        VStack {
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
        }
        .padding(.top, 12)
        .scrollIndicators(.hidden)
        .navigationTitle("Events")
    }
    
    @ViewBuilder
    private func row(firstEvent: Event, secondEvent: Event? = nil) -> some View {
        if let secondEvent {
            HStack(alignment: .top, spacing: 12) {
                Spacer()
                
                VStack(alignment: .leading) {
                    NavigationLink(
                        destination: EventInfoView(event: firstEvent),
                        label: {
                            ImageScrollingView(images: firstEvent.images, onTapCenter: nil)
                                .frame(width: 156, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    )
                    
                    HStack {
                        Text(firstEvent.name)
                            .font(.headline)
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
                            ImageScrollingView(images: secondEvent.images, onTapCenter: nil)
                                .frame(width: 156, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    )
                    HStack {
                        Text(secondEvent.name)
                            .font(.headline)
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
                            ImageScrollingView(images: firstEvent.images, onTapCenter: nil)
                                .frame(width: 156, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    )
                    
                    HStack {
                        Text(firstEvent.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .frame(width: 156)
                        
                        Spacer()
                    }
                }
                
                VStack {
                    ImageScrollingView(images: firstEvent.images, onTapCenter: nil)
                        .frame(width: 156, height: 200)
                    
                    HStack {
                        Text(firstEvent.name)
                            .font(.headline)
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

#Preview {
    EventsView()
}
