import Foundation
import SwiftUI

@MainActor
final class ProductsViewModel: ObservableObject {
    let personalized: Bool
    let fromHome: Bool

    @Published var searchText: String = ""
    @Published var selectedCategory: ProductCategory = .all
    @Published var products: [Product] = []
    @Published var allProducts: [Product] = []

    init(personalized: Bool, fromHome: Bool) {
        self.personalized = personalized
        self.fromHome = fromHome
        self.allProducts = Self.mockProducts()
        self.products = allProducts
        if personalized {
            applyPersonalizedSort()
        }
    }

    var filteredCount: Int {
        products.count
    }

    var personalizedSummary: String {
        "Products ranked by match with your Normal skin and Large pores concerns"
    }

    func applySearchAndFilter() {
        var result = allProducts
        if selectedCategory != .all {
            result = result.filter { $0.category == selectedCategory }
        }
        if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            let q = searchText.lowercased()
            result = result.filter {
                $0.name.lowercased().contains(q) ||
                $0.brand.lowercased().contains(q) ||
                $0.tags.contains { $0.lowercased().contains(q) }
            }
        }
        if personalized {
            result.sort { $0.matchScore > $1.matchScore }
        }
        products = result
    }

    private func applyPersonalizedSort() {
        products = products.sorted { $0.matchScore > $1.matchScore }
    }

        static func mockProducts() -> [Product] {
        let url: (String) -> String? = { id in "https://www.amazon.com/dp/\(id)" }
        return [
            Product(id: "1", name: "C E Ferulic", brand: "SkinCeuticals", priceTier: .premium, tags: ["Vitamin C", "Ferulic Acid", "E"], category: .serum, matchScore: 0.95, imageName: "product_1", amazonUrl: url("1")),
            Product(id: "2", name: "Gentle Cleanser", brand: "CeraVe", priceTier: .budget, tags: ["Ceramides", "Hyaluronic Acid"], category: .cleanser, matchScore: 0.92, imageName: "product_2", amazonUrl: url("2")),
            Product(id: "3", name: "Advanced Night Repair", brand: "Estée Lauder", priceTier: .premium, tags: ["Peptides", "Hyaluronic Acid"], category: .serum, matchScore: 0.88, imageName: "product_3", amazonUrl: url("3")),
            Product(id: "4", name: "Hydrating Toner", brand: "Paula's Choice", priceTier: .mid, tags: ["AHA", "Glycolic Acid"], category: .toner, matchScore: 0.85, imageName: "product_4", amazonUrl: url("4")),
            Product(id: "5", name: "Daily Moisturizer SPF 30", brand: "La Roche-Posay", priceTier: .mid, tags: ["Niacinamide", "SPF"], category: .sunscreen, matchScore: 0.82, imageName: "product_5", amazonUrl: url("5")),
            Product(id: "13", name: "Anthelios Melt-in Milk SPF 60", brand: "La Roche-Posay", priceTier: .mid, tags: ["SPF", "Alcohol-Free", "Fragrance-Free", "Cruelty-Free", "Vegan"], category: .sunscreen, matchScore: 0.90, imageName: "product_6", amazonUrl: url("13")),
            Product(id: "6", name: "Retinol Serum", brand: "The Ordinary", priceTier: .budget, tags: ["Retinol", "Squalane"], category: .serum, matchScore: 0.80, imageName: "product_7", amazonUrl: url("6")),
            Product(id: "7", name: "B5 Hydrating Gel", brand: "SkinCeuticals", priceTier: .mid, tags: ["Vitamin B5", "Hyaluronic Acid"], category: .serum, matchScore: 0.78, imageName: "product_8", amazonUrl: url("7")),
            Product(id: "8", name: "Foaming Cleanser", brand: "CeraVe", priceTier: .budget, tags: ["Ceramides", "Niacinamide"], category: .cleanser, matchScore: 0.75, imageName: "product_9", amazonUrl: url("8")),
            Product(id: "9", name: "Resurfacing Mask", brand: "Drunk Elephant", priceTier: .premium, tags: ["AHA", "BHA", "Glycolic Acid"], category: .mask, matchScore: 0.72, imageName: "product_10", amazonUrl: url("9")),
            Product(id: "10", name: "Barrier Repair Cream", brand: "Kiehl's", priceTier: .mid, tags: ["Ceramides", "Squalane"], category: .moisturizer, matchScore: 0.70, imageName: "product_11", amazonUrl: url("10")),
            Product(id: "11", name: "Niacinamide 10%", brand: "The Ordinary", priceTier: .budget, tags: ["Niacinamide", "Zinc"], category: .serum, matchScore: 0.68, imageName: "product_12", amazonUrl: url("11")),
            Product(id: "12", name: "Ultra Facial Cream", brand: "Kiehl's", priceTier: .mid, tags: ["Squalane", "Glacier Glycoprotein"], category: .moisturizer, matchScore: 0.65, imageName: "product_13", amazonUrl: url("12")),
        ]
    }
}
