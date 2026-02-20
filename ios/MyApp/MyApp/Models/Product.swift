import Foundation

struct Product: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let brand: String
    let priceTier: PriceTier
    let tags: [String]
    let category: ProductCategory
    let matchScore: Double
    /// Asset catalog image name, or nil for placeholder.
    let imageName: String?
    /// Amazon product URL for "Open in Amazon" / cart deep link. Nil if not available.
    let amazonUrl: String?
}

enum PriceTier: String, CaseIterable, Codable {
    case budget = "$"
    case mid = "$$"
    case premium = "$$$"

    var display: String { rawValue }
}
