import Foundation

enum ProductCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case cleanser = "Cleanser"
    case toner = "Toner"
    case serum = "Serum"
    case moisturizer = "Moisturizer"
    case sunscreen = "Sunscreen"
    case mask = "Mask"
    case other = "Other"

    var id: String { rawValue }
}
