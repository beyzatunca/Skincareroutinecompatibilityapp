import Foundation

/// Time of day for adding a product to the routine.
enum RoutineTimeOfDay: String, CaseIterable {
    case am = "AM"
    case pm = "PM"
    case both = "Both"
}

/// Frequency for product use in the routine.
enum RoutineFrequency: String, CaseIterable {
    case daily = "Daily"
    case twoThreePerWeek = "2-3 times per week"
    case alternateDays = "Alternate days"
}

/// User's selection when adding a product to routine.
struct RoutineSelection {
    var timeOfDay: RoutineTimeOfDay
    var frequency: RoutineFrequency

    static let `default` = RoutineSelection(timeOfDay: .pm, frequency: .daily)
}
