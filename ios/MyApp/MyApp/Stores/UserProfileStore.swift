import Foundation
import SwiftUI

/// Persisted profile state from the personalized survey (Profile flow).
/// Uses same types as Survey (SurveyAgeRange, SurveySkinType, etc.).
final class UserProfileStore: ObservableObject {
    private enum Keys {
        static let ageRange = "userProfile_ageRange"
        static let skinType = "userProfile_skinType"
        static let concerns = "userProfile_concerns"
        static let hasSensitiveSkin = "userProfile_hasSensitiveSkin"
        static let avoidedIngredients = "userProfile_avoidedIngredients"
        static let isPregnant = "userProfile_isPregnant"
        static let isSurveyCompleted = "userProfile_isSurveyCompleted"
    }

    @Published var ageRange: SurveyAgeRange? {
        didSet { persistAgeRange() }
    }
    @Published var skinType: SurveySkinType? {
        didSet { persistSkinType() }
    }
    @Published var concerns: Set<SurveyConcern> = [] {
        didSet { persistConcerns() }
    }
    @Published var hasSensitiveSkin: Bool = false {
        didSet { UserDefaults.standard.set(hasSensitiveSkin, forKey: Keys.hasSensitiveSkin) }
    }
    @Published var avoidedIngredients: Set<SurveyAvoidance> = [] {
        didSet { persistAvoidedIngredients() }
    }
    @Published var isPregnant: Bool = false {
        didSet { UserDefaults.standard.set(isPregnant, forKey: Keys.isPregnant) }
    }
    @Published var isSurveyCompleted: Bool = false {
        didSet { UserDefaults.standard.set(isSurveyCompleted, forKey: Keys.isSurveyCompleted) }
    }

    /// Single source of truth for "has completed survey/profile at least once". Used for Home Add Products and Discover routing.
    var isPersonalizedEnabled: Bool { isSurveyCompleted }

    private let defaults = UserDefaults.standard

    init() {
        loadFromUserDefaults()
    }

    func loadFromUserDefaults() {
        if let raw = defaults.string(forKey: Keys.ageRange), let value = SurveyAgeRange(rawValue: raw) {
            ageRange = value
        } else {
            ageRange = nil
        }
        if let raw = defaults.string(forKey: Keys.skinType), let value = SurveySkinType(rawValue: raw) {
            skinType = value
        } else {
            skinType = nil
        }
        concerns = loadConcerns()
        hasSensitiveSkin = defaults.bool(forKey: Keys.hasSensitiveSkin)
        avoidedIngredients = loadAvoidedIngredients()
        isPregnant = defaults.bool(forKey: Keys.isPregnant)
        isSurveyCompleted = defaults.bool(forKey: Keys.isSurveyCompleted)
    }

    /// Clear all profile/survey data and persist so app behaves like first-time. Resets isSurveyCompleted so Home/Discover routing updates.
    func resetProfile() {
        clearUserDefaultsKeys()
        ageRange = nil
        skinType = nil
        concerns = []
        hasSensitiveSkin = false
        avoidedIngredients = []
        isPregnant = false
        isSurveyCompleted = false
    }

    private func clearUserDefaultsKeys() {
        defaults.removeObject(forKey: Keys.ageRange)
        defaults.removeObject(forKey: Keys.skinType)
        defaults.removeObject(forKey: Keys.concerns)
        defaults.removeObject(forKey: Keys.hasSensitiveSkin)
        defaults.removeObject(forKey: Keys.avoidedIngredients)
        defaults.removeObject(forKey: Keys.isPregnant)
        defaults.removeObject(forKey: Keys.isSurveyCompleted)
    }

    /// Write all current selections from the survey view model into the store and mark completed.
    func applySurveyResult(
        ageRange: SurveyAgeRange?,
        skinType: SurveySkinType?,
        concerns: Set<SurveyConcern>,
        hasSensitiveSkin: Bool,
        avoidedIngredients: Set<SurveyAvoidance>,
        isPregnant: Bool
    ) {
        self.ageRange = ageRange
        self.skinType = skinType
        self.concerns = concerns
        self.hasSensitiveSkin = hasSensitiveSkin
        self.avoidedIngredients = avoidedIngredients
        self.isPregnant = isPregnant
        self.isSurveyCompleted = true
    }

    private func persistAgeRange() {
        defaults.set(ageRange?.rawValue, forKey: Keys.ageRange)
    }

    private func persistSkinType() {
        defaults.set(skinType?.rawValue, forKey: Keys.skinType)
    }

    private func persistConcerns() {
        let raw = concerns.map(\.rawValue)
        defaults.set(raw, forKey: Keys.concerns)
    }

    private func loadConcerns() -> Set<SurveyConcern> {
        guard let list = defaults.array(forKey: Keys.concerns) as? [String] else { return [] }
        return Set(list.compactMap { SurveyConcern(rawValue: $0) })
    }

    private func persistAvoidedIngredients() {
        let raw = avoidedIngredients.map(\.rawValue)
        defaults.set(raw, forKey: Keys.avoidedIngredients)
    }

    private func loadAvoidedIngredients() -> Set<SurveyAvoidance> {
        guard let list = defaults.array(forKey: Keys.avoidedIngredients) as? [String] else { return [] }
        return Set(list.compactMap { SurveyAvoidance(rawValue: $0) })
    }
}
