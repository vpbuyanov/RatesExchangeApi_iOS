struct CurrencyHistory: Decodable, Sendable {
    let symbol: String
    let description: String
    let rates: [CurrencyHistoryRate]
}

struct CurrencyHistoryRate: Decodable, Sendable {
    let date: String
    let value: Double
}
