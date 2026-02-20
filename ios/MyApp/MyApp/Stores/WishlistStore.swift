import Foundation
import SwiftUI

/// Persisted wishlist: add/remove products by id, sync with UserDefaults.
final class WishlistStore: ObservableObject {
    private static let key = "wishlistProducts"

    @Published var items: [Product] = [] {
        didSet { save() }
    }

    init() {
        load()
    }

    func isWishlisted(_ product: Product) -> Bool {
        items.contains { $0.id == product.id }
    }

    /// Add if not present, remove if present. Deduplicates by product.id.
    func toggle(_ product: Product) {
        if let index = items.firstIndex(where: { $0.id == product.id }) {
            items.remove(at: index)
        } else {
            items.append(product)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.key),
              let decoded = try? JSONDecoder().decode([Product].self, from: data) else {
            items = []
            return
        }
        items = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: Self.key)
    }
}
