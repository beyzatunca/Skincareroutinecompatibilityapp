import Foundation

/// A product in the user's routine with editable time of day and frequency.
struct RoutineItem: Identifiable, Equatable {
    let id: String
    var product: Product
    var timeOfDay: RoutineTimeOfDay
    var frequency: RoutineFrequency

    init(id: String, product: Product, timeOfDay: RoutineTimeOfDay, frequency: RoutineFrequency) {
        self.id = id
        self.product = product
        self.timeOfDay = timeOfDay
        self.frequency = frequency
    }

    static func == (lhs: RoutineItem, rhs: RoutineItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - RoutineTimeOfDay helpers

extension RoutineTimeOfDay {
    func includesAM() -> Bool {
        self == .am || self == .both
    }

    func includesPM() -> Bool {
        self == .pm || self == .both
    }
}

// MARK: - RoutineFrequency short chip label

extension RoutineFrequency {
    /// Short label for routine screen chips (e.g. "2-3x/week", "Alternate").
    var chipLabel: String {
        switch self {
        case .daily: return "Daily"
        case .twoThreePerWeek: return "2-3x/week"
        case .alternateDays: return "Alternate"
        }
    }
}
