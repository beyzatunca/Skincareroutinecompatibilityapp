import Foundation
import SwiftUI

@MainActor
final class ProductDetailViewModel: ObservableObject {
    let productId: String
    let personalized: Bool

    @Published private(set) var product: Product?

    init(productId: String, personalized: Bool) {
        self.productId = productId
        self.personalized = personalized
        self.product = Self.loadProduct(id: productId)
    }

    private static func loadProduct(id: String) -> Product? {
        ProductsViewModel.mockProducts().first { $0.id == id }
    }

    var attributePills: [String] {
        product?.tags ?? []
    }

    var showMatchCard: Bool {
        personalized && product != nil
    }

    var skinTypeText: String {
        "Based on your Combination skin type"
    }

    var matchBullets: [String] {
        guard product != nil else { return [] }
        return [
            "Oil Control: Lightweight formula won't clog pores or feel greasy"
        ]
    }

    var benefitsSectionTitle: String {
        "Benefits for Your Combination Skin"
    }

    var placeholderBenefits: [String] {
        [
            "Broad spectrum SPF 60 protection",
            "Lightweight, non-greasy texture",
            "Suitable for sensitive skin"
        ]
    }

    /// Mock positive effects for non-personalized mode (derived from tags when possible).
    var positiveEffects: [(title: String, description: String)] {
        let tags = (product?.tags ?? []).map { $0.lowercased() }
        var list: [(String, String)] = []
        if tags.contains(where: { $0.contains("aha") || $0.contains("glycolic") }) {
            list.append(("Exfoliating", "Removes dead skin cells for smoother texture"))
            list.append(("Brightening", "Improves skin radiance and tone"))
        }
        if tags.contains(where: { $0.contains("retinol") || $0.contains("retinoid") }) {
            list.append(("Anti-Aging", "Reduces fine lines and wrinkles"))
        }
        if list.isEmpty {
            list = [
                ("Exfoliating", "Removes dead skin cells for smoother texture"),
                ("Brightening", "Improves skin radiance and tone"),
                ("Anti-Aging", "Reduces fine lines and wrinkles")
            ]
        }
        return list
    }

    /// Mock negative effects for non-personalized mode (derived from tags when possible).
    var negativeEffects: [(title: String, active: String)] {
        let tags = product?.tags ?? []
        let hasAha = tags.contains(where: { $0.lowercased().contains("aha") || $0.lowercased().contains("glycolic") })
        if hasAha {
            return [
                ("Skin Irritation", "Active: Glycolic Acid (AHA)"),
                ("Sun Sensitivity", "Active: Glycolic Acid")
            ]
        }
        return [
            ("Skin Irritation", "Active: See key actives"),
            ("Sun Sensitivity", "Use SPF when using actives")
        ]
    }
}
