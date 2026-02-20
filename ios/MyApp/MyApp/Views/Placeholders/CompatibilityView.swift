import SwiftUI

/// "Routine Analysis" loading screen: spinner, "Analyzing Your Routine", three step cards. On completion navigates to compatibility results or product compatibility (when productId is set).
struct CompatibilityView: View {
    @Binding var path: NavigationPath
    /// When set (from Discover Product Detail), on completion navigate to Product Compatibility instead of full Compatibility Results.
    var productId: String? = nil

    /// Step state for the three analysis steps.
    enum StepState {
        case pending
        case inProgress
        case completed
    }

    @State private var step1: StepState = .completed
    @State private var step2: StepState = .inProgress
    @State private var step3: StepState = .pending
    @State private var hasNavigatedToResults = false

    private static let cardCornerRadius: CGFloat = 16
    private static let stepIconSize: CGFloat = 24
    private static let step2CompleteDelay: Double = 1.8
    private static let step3CompleteAndNavigateDelay: Double = 3.6

    var body: some View {
        ZStack {
            backgroundGradient
            VStack(spacing: Design.space24) {
                ProgressView()
                    .scaleEffect(1.4)
                    .tint(Color(hex: "374151"))
                Text("Analyzing Your Routine")
                    .font(.system(size: Design.headerTitleFontSize, weight: .bold))
                    .foregroundColor(Color(hex: "111827"))
                stepsSection
            }
            .padding(.horizontal, Design.contentHorizontalPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: startStepProgression)
    }

    private func startStepProgression() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.step2CompleteDelay) {
            step2 = .completed
            step3 = .inProgress
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.step3CompleteAndNavigateDelay) {
            step3 = .completed
            guard !hasNavigatedToResults else { return }
            hasNavigatedToResults = true
            if let productId = productId {
                path.removeLast()
                path.append(AppRoute.productCompatibility(productId: productId))
            } else {
                path.append(AppRoute.compatibilityResults)
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(hex: "E8E4F0"),
                Color(hex: "F5E6E0")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var stepsSection: some View {
        VStack(spacing: Design.space16) {
            stepRow(
                state: step1,
                text: "Checking ingredient conflicts..."
            )
            stepRow(
                state: step2,
                text: "Detecting overlapping actives..."
            )
            stepRow(
                state: step3,
                text: "Building your safest schedule..."
            )
        }
    }

    private func stepRow(state: StepState, text: String) -> some View {
        HStack(spacing: Design.space12) {
            stepIcon(state: state)
            Text(text)
                .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                .foregroundColor(state == .pending ? Color(hex: "9CA3AF") : Color(hex: "111827"))
            Spacer(minLength: 8)
        }
        .padding(.horizontal, Design.space16)
        .padding(.vertical, Design.space16)
        .background(
            RoundedRectangle(cornerRadius: Self.cardCornerRadius)
                .fill(Color.white)
        )
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }

    @ViewBuilder
    private func stepIcon(state: StepState) -> some View {
        switch state {
        case .completed:
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: Self.stepIconSize))
                .foregroundColor(Color(hex: "059669"))
        case .inProgress:
            ProgressView()
                .scaleEffect(0.9)
                .tint(Color(hex: "0EA5E9"))
        case .pending:
            Image(systemName: "circle")
                .font(.system(size: Self.stepIconSize))
                .foregroundColor(Color(hex: "D1D5DB"))
        }
    }
}

#Preview {
    NavigationStack {
        CompatibilityView(path: .constant(NavigationPath()))
    }
}
