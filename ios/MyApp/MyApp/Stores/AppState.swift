import Foundation
import SwiftUI

/// App-wide UI state: selected tab, toast, survey completion, and navigation requests.
final class AppState: ObservableObject {
    /// UserDefaults key for survey completion. Default: false. Load on init, save on change.
    static let surveyCompletedKey = "isPersonalizedSurveyCompleted"

    @Published var selectedTab: AppTab = .home
    @Published var toast: ToastState?
    /// When true, MainTabView should pop home stack to root and then clear this flag.
    @Published var requestPopHomeToRoot = false
    @Published var isPersonalizedSurveyCompleted: Bool

    init() {
        self.isPersonalizedSurveyCompleted = UserDefaults.standard.bool(forKey: Self.surveyCompletedKey)
    }

    func setSurveyCompleted(_ value: Bool) {
        isPersonalizedSurveyCompleted = value
        UserDefaults.standard.set(value, forKey: Self.surveyCompletedKey)
    }

    /// Re-read survey completion from UserDefaults (e.g. when opening Discover tab).
    func syncSurveyStateFromUserDefaults() {
        isPersonalizedSurveyCompleted = UserDefaults.standard.bool(forKey: Self.surveyCompletedKey)
    }

    /// Show a toast banner at the top. HomeView observes `toast` and renders ToastBanner.
    func showToast(type: ToastType, message: String) {
        toast = ToastState(type: type, message: message)
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
