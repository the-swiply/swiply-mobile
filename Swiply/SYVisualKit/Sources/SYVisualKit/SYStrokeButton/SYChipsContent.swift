import SwiftUI

public struct SYChipsContent: View {
    private let interests = ["ios" ,"android" ,"путешествия" ,"велосипед" ,"кулинария" ,"животные" ,"музыка"  ,"Teaтp"  ,"it" ,"суши" ,"книги"  ,"йога" ,"фотография" ,"стендап" ,"ландшафтный дизайн" , "тату", "иностранные языки" ,"танцы" ,"восточные танцы" ,"спорт","пошив одежды", "медитации", "бег" ,"здоровый образ жизни", "пицца"]
    private let action: (String) -> Void
    
    public init(action: @escaping (String) -> Void) {
        self.action = action
    }
    
    public var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        VStack {
        GeometryReader { geo in
                ZStack(alignment: .topLeading, content: {
                    ForEach(interests, id: \.self) { chipsData in
                        SYChip(text: chipsData, action: { str in
                            action(str)
                        })
                            
                            .padding(.all, 4)
                            .alignmentGuide(.leading) { dimension in
                                if (abs(width - dimension.width) > geo.size.width) {
                                    width = 0
                                    height -= dimension.height
                                }
                                
                                let result = width
                                if chipsData == interests.last {
                                    width = 0
                                } else {
                                    width -= dimension.width
                                }
                                return result
                            }
                            .alignmentGuide(.top) { _ in
                                let result = height
                                if chipsData == interests.last {
                                    height = 0
                                }
                                return result
                            }
                    }
                 
                })
                
            }
        }
    }
}


struct SYChipsContent_Preview: PreviewProvider {
    static var previews: some View {
        SYChipsContent(action: { str in
            print(str)
        })
    }
}

