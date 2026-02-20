import Foundation
import SwiftUI

@MainActor
final class PersonalizedSurveyViewModel: ObservableObject {
    // Step
    @Published var currentStep: Int = 1
    let totalSteps = 3

    // Step 1
    @Published var selectedAgeRange: SurveyAgeRange?
    @Published var selectedSkinType: SurveySkinType?

    // Step 2
    @Published var selectedConcerns: Set<SurveyConcern> = []
    @Published var hasSensitiveSkin: Bool = false

    // Step 3
    @Published var avoidedIngredients: Set<SurveyAvoidance> = []
    @Published var isPregnant: Bool = false

    /// Must match AppState.surveyCompletedKey so persistence is shared.
    static let surveyCompletedKey = "isPersonalizedSurveyCompleted"

    // Navigation
    var onDismiss: (() -> Void)?
    var onComplete: (() -> Void)?

    /// Step 1: Continue enabled only when both age range and skin type are selected.
    var canContinueStepOne: Bool {
        selectedAgeRange != nil && selectedSkinType != nil
    }

    /// Step 2: Continue enabled when at least one concern or sensitive-skin checkbox is selected.
    var canContinueStepTwo: Bool {
        !selectedConcerns.isEmpty || hasSensitiveSkin
    }

    /// Step 3: Optional step; final CTA is always enabled.
    var canFinishSurvey: Bool { true }

    func goBack() {
        if currentStep > 1 {
            currentStep -= 1
        } else {
            onDismiss?()
        }
    }

    func goNext() {
        if currentStep < totalSteps {
            currentStep += 1
        } else {
            onComplete?()
        }
    }

    /// Persist that the user completed the personalized survey (e.g. from Home).
    func markSurveyCompleted() {
        UserDefaults.standard.set(true, forKey: Self.surveyCompletedKey)
    }

    func toggleConcern(_ concern: SurveyConcern) {
        if selectedConcerns.contains(concern) {
            selectedConcerns.remove(concern)
        } else {
            selectedConcerns.insert(concern)
        }
    }

    func toggleAvoidance(_ item: SurveyAvoidance) {
        if avoidedIngredients.contains(item) {
            avoidedIngredients.remove(item)
        } else {
            avoidedIngredients.insert(item)
        }
    }
}
