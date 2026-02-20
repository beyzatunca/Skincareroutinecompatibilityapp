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
    /// Full ingredient list; shown when "See full list of ingredients" is tapped. Nil = use tags.
    let ingredients: [String]?

    init(id: String, name: String, brand: String, priceTier: PriceTier, tags: [String], category: ProductCategory, matchScore: Double, imageName: String?, amazonUrl: String?, ingredients: [String]? = nil) {
        self.id = id
        self.name = name
        self.brand = brand
        self.priceTier = priceTier
        self.tags = tags
        self.category = category
        self.matchScore = matchScore
        self.imageName = imageName
        self.amazonUrl = amazonUrl
        self.ingredients = ingredients
    }
}

enum PriceTier: String, CaseIterable, Codable {
    case budget = "$"
    case mid = "$$"
    case premium = "$$$"

    var display: String { rawValue }
}
