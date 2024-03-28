import SwiftUI

struct MatchesRow: View {
    
    var matches: [Matches]
    let action: (Matches) -> Void
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Лайки")
                .bold()
                .font(.subheadline)
                .foregroundStyle(.pink)
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 10) {
                    ForEach(matches) { match in
                        Image(uiImage: match.person.images.first!!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.white, lineWidth: 5))
                            .overlay(Circle().stroke(.pink, lineWidth: match.isViewed ? 0 : 1))
                            .padding(1)
                            .onTapGesture {
                                print("Match")
                                action(match)
                            }
                    }
                }
                .padding(.leading)
                
            }
        }
    }
}

//#Preview {
//    MatchesRow()
//}
