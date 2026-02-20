import Foundation
import SwiftUI

/// ViewModel for Analysis Results: accordion state, Morning/Evening segment, mock schedule lists.
final class CompatibilityResultsViewModel: ObservableObject {
    /// Morning / Evening segment (matches "Your Safe Schedule" pills).
    enum ScheduleSegment: String, CaseIterable {
        case morning = "Morning"
        case evening = "Evening"
    }

    @Published var selectedSegment: ScheduleSegment = .morning
    @Published var isIngredientConflictsExpanded: Bool = false
    @Published var isSkinBarrierDamageExpanded: Bool = false

    /// Mock morning products for "Your Safe Schedule" list.
    let morningProducts: [String] = [
        "Anthelios Melt-in Milk SPF 60"
    ]

    /// Mock evening products (different list when segment is Evening).
    let eveningProducts: [String] = [
        "CeraVe PM Moisturizer",
        "The Ordinary Retinol 0.5%"
    ]

    var currentScheduleProducts: [String] {
        switch selectedSegment {
        case .morning: return morningProducts
        case .evening: return eveningProducts
        }
    }
}
