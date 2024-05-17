import SwiftUI

public struct Event: Equatable {
    let id: String
    let name: String
    let description: String
    let date: Date
    let images: [UIImage]
}


extension NetworkingEvent {

    var toEvent: Event {
        .init(
            id: self.event_id,
            name: self.title,
            description: self.description,
            date: DateFormatter.server.date(from: self.date) ?? Date(),
            images: self.photos.compactMap { imageString in
                if let data = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters) {
                    return UIImage(data: data) ?? UIImage(resource: .animal)
                }

                return nil
            })
    }

}
