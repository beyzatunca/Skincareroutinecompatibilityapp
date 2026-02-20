import Foundation
import SwiftUI

/// Single source of truth for routine items. Home thumbnails are derived from computed morning/evening lists.
final class RoutineStore: ObservableObject {
    @Published var items: [RoutineItem] = []

    var morningProducts: [Product] {
        items.filter { $0.timeOfDay.includesAM() }.map(\.product)
    }

    var eveningProducts: [Product] {
        items.filter { $0.timeOfDay.includesPM() }.map(\.product)
    }

    /// True when at least one product is in the routine (used for Check Compatibility guard).
    var hasAnyProducts: Bool {
        !items.isEmpty
    }

    /// Add or update by product.id. If exists, updates timeOfDay and frequency; otherwise appends.
    func addOrUpdate(product: Product, timeOfDay: RoutineTimeOfDay, frequency: RoutineFrequency) {
        if let index = items.firstIndex(where: { $0.id == product.id }) {
            items[index].product = product
            items[index].timeOfDay = timeOfDay
            items[index].frequency = frequency
        } else {
            items.append(RoutineItem(id: product.id, product: product, timeOfDay: timeOfDay, frequency: frequency))
        }
    }

    func update(itemId: String, timeOfDay: RoutineTimeOfDay, frequency: RoutineFrequency) {
        guard let index = items.firstIndex(where: { $0.id == itemId }) else { return }
        items[index].timeOfDay = timeOfDay
        items[index].frequency = frequency
    }

    func delete(itemId: String) {
        items.removeAll { $0.id == itemId }
    }
}
