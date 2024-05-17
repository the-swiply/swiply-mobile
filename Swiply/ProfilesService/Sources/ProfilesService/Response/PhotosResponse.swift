// MARK: - PhotosResponse

public struct PhotosResponse: Codable {
    let photos: [Photo]
}

// MARK: - Photo
public struct Photo: Codable {
    let id, content: String
}
