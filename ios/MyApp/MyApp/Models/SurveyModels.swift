import Foundation

// MARK: - Entry source

enum SurveyEntrySource: Equatable {
    case fromHome
    case fromProfile
    case fromProductDetail(productId: String)

    var isFromProductDetail: Bool {
        if case .fromProductDetail = self { return true }
        return false
    }
}

// MARK: - Step 1

enum SurveyAgeRange: String, CaseIterable, Identifiable {
    case under18 = "Under 18"
    case age18_24 = "18–24"
    case age25_30 = "25–30"
    case age31_40 = "31–40"
    case age40Plus = "40+"
    var id: String { rawValue }
}

enum SurveySkinType: String, CaseIterable, Identifiable {
    case dry = "Dry"
    case oily = "Oily"
    case combination = "Combination"
    case normal = "Normal"
    case sensitive = "Sensitive"
    var id: String { rawValue }
}

// MARK: - Step 2

enum SurveyConcern: String, CaseIterable, Identifiable {
    case acne = "Acne"
    case aging = "Aging"
    case hyperpigmentation = "Hyperpigmentation"
    case dryness = "Dryness"
    case texture = "Texture"
    case redness = "Redness"
    case largePores = "Large pores"
    var id: String { rawValue }
}

// MARK: - Step 3

enum SurveyAvoidance: String, CaseIterable, Identifiable {
    case fragrance = "Fragrance"
    case essentialOils = "Essential oils"
    case alcohol = "Alcohol"
    case sulfates = "Sulfates"
    case parabens = "Parabens"
    var id: String { rawValue }
}
