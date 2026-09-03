struct ErrorModel: Decodable, Sendable {
    let code: String?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case message = "Message"
    }
}
