struct RatesDetailModel: Decodable, Sendable {
    let base: String
    let date: String
    let rates: [RateDetail]
}

struct RateDetail: Decodable, Sendable {
    let symbol: String
    let currency: String
    let value: Double
}
