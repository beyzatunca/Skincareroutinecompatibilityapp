import Foundation
import SwiftUI

/// App-wide UI state: selected tab, toast, survey completion, and navigation requests.
final class AppState: ObservableObject {
    /// UserDefaults key for survey completion. Default: false. Load on init, save on change.
    static let surveyCompletedKey = "isPersonalizedSurveyCompleted"
    /// UserDefaults key for last compatibility score. Gauge visibility is session-only (not persisted).
    static let lastCompatibilityScoreKey = "lastCompatibilityScore"

    /// Auto-dismiss delay for toast (show then slide away).
    static let toastAutoDismissSeconds: Double = 2.5

    @Published var selectedTab: AppTab = .home
    @Published var toast: ToastState?
    private var toastDismissWorkItem: DispatchWorkItem?
    /// When true, MainTabView should pop home stack to root and then clear this flag.
    @Published var requestPopHomeToRoot = false
    @Published var isPersonalizedSurveyCompleted: Bool
    /// True only after user has seen Analysis Results in this session (add products → Check Compatibility → results). Not persisted.
    @Published var hasCompletedCompatibilityCheck: Bool = false
    /// Last compatibility score (0–100) to show in gauge; persisted.
    @Published var lastCompatibilityScore: Int

    init() {
        self.isPersonalizedSurveyCompleted = UserDefaults.standard.bool(forKey: Self.surveyCompletedKey)
        let saved = UserDefaults.standard.object(forKey: Self.lastCompatibilityScoreKey) as? Int
        self.lastCompatibilityScore = saved ?? 74
    }

    func setSurveyCompleted(_ value: Bool) {
        isPersonalizedSurveyCompleted = value
        UserDefaults.standard.set(value, forKey: Self.surveyCompletedKey)
    }

    /// Call when user has seen compatibility results (e.g. CompatibilityResultsView onAppear). Shows gauge on Home until app is closed. Not persisted.
    func setCompatibilityCheckCompleted(_ value: Bool, score: Int? = nil) {
        hasCompletedCompatibilityCheck = value
        if let score = score {
            lastCompatibilityScore = min(100, max(0, score))
            UserDefaults.standard.set(lastCompatibilityScore, forKey: Self.lastCompatibilityScoreKey)
        }
    }

    /// Re-read survey completion from UserDefaults (e.g. when opening Discover tab).
    func syncSurveyStateFromUserDefaults() {
        isPersonalizedSurveyCompleted = UserDefaults.standard.bool(forKey: Self.surveyCompletedKey)
    }

    /// Show a toast banner at the top. Auto-dismisses after a short delay so it slides away.
    func showToast(type: ToastType, message: String) {
        toastDismissWorkItem?.cancel()
        toast = ToastState(type: type, message: message)
        let work = DispatchWorkItem { [weak self] in
            DispatchQueue.main.async {
                self?.toast = nil
            }
        }
        toastDismissWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.toastAutoDismissSeconds, execute: work)
    }
}

/// Toast type for banner styling (success = green, error = red, info = neutral).
enum ToastType: Equatable {
    case success
    case error
    case info
}

/// Toast shown at top of screen (e.g. "Product added successfully", "Please add products first").
struct ToastState: Equatable {
    let type: ToastType
    let message: String

    /// Legacy initializer for success toasts (style-based).
    init(message: String, style: ToastStyle) {
        self.type = style == .success ? .success : .error
        self.message = message
    }

    init(type: ToastType, message: String) {
        self.type = type
        self.message = message
    }
}

/// Legacy style enum; prefer ToastType. Kept for existing ToastState(message:style:) call sites.
enum ToastStyle: Equatable {
    case success
}
