import Foundation

/// Route params for Products screen (equivalent to /products?personalized=&fromHome=).
struct ProductsRoute: Identifiable, Equatable, Hashable {
    let personalized: Bool
    let fromHome: Bool
    var id: String { "\(personalized)-\(fromHome)" }
}
