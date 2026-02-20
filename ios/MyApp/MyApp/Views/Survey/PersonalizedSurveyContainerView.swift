import SwiftUI

struct PersonalizedSurveyContainerView: View {
    /// Binding to the root NavigationPath so we can pop (back) or replace with products (complete).
    var path: Binding<NavigationPath>? = nil
    var source: SurveyEntrySource = .fromHome
    @StateObject private var viewModel = PersonalizedSurveyViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userProfileStore: UserProfileStore

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                topBar
                stepContentScroll
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, Design.surveyStickyCTAStripHeight)

            stickyCTAStrip
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, Design.tabBarEstimatedHeight)
        .background(Color.white)
        .navigationBarHidden(true)
        .onAppear {
            if (source == .fromProfile || source.isFromProductDetail) && userProfileStore.isSurveyCompleted {
                viewModel.selectedAgeRange = userProfileStore.ageRange
                viewModel.selectedSkinType = userProfileStore.skinType
                viewModel.selectedConcerns = userProfileStore.concerns
                viewModel.hasSensitiveSkin = userProfileStore.hasSensitiveSkin
                viewModel.avoidedIngredients = userProfileStore.avoidedIngredients
                viewModel.isPregnant = userProfileStore.isPregnant
            }
            viewModel.onDismiss = {
                if let path, path.wrappedValue.count > 0 {
                    path.wrappedValue.removeLast()
                } else {
                    dismiss()
                }
            }
            viewModel.onComplete = {
                viewModel.markSurveyCompleted()
                userProfileStore.applySurveyResult(
                    ageRange: viewModel.selectedAgeRange,
                    skinType: viewModel.selectedSkinType,
                    concerns: viewModel.selectedConcerns,
                    hasSensitiveSkin: viewModel.hasSensitiveSkin,
                    avoidedIngredients: viewModel.avoidedIngredients,
                    isPregnant: viewModel.isPregnant
                )
                if case .fromProductDetail = source, let path, path.wrappedValue.count > 0 {
                    path.wrappedValue.removeLast()
                } else if source == .fromProfile {
                    dismiss()
                } else if let path, path.wrappedValue.count > 0 {
                    path.wrappedValue.removeLast()
                    path.wrappedValue.append(AppRoute.products(personalized: true, fromHome: true))
                } else {
                    dismiss()
                }
            }
        }
    }

    /// Step content only (scrollable body), no CTA — CTA is at container level below.
    @ViewBuilder
    private var stepContentScroll: some View {
        switch viewModel.currentStep {
        case 1:
            SurveyStepOneView(viewModel: viewModel)
        case 2:
            SurveyStepTwoView(viewModel: viewModel)
        case 3:
            SurveyStepThreeView(viewModel: viewModel)
        default:
            EmptyView()
        }
    }

    /// Single sticky CTA strip at bottom; title and enable state depend on current step. Overlay so it is always visible.
    private var stickyCTAStrip: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(hex: "E5E7EB"))
                .frame(height: 1)
            stepCTAButton
                .padding(.horizontal, Design.surveyHorizontalMargin)
                .padding(.top, Design.space16)
                .padding(.bottom, Design.surveyStickyCTABottomPadding)
        }
        .background(Color.white)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: -2)
    }

    @ViewBuilder
    private var stepCTAButton: some View {
        switch viewModel.currentStep {
        case 1:
            SurveyPrimaryButton(
                title: "Continue",
                isEnabled: viewModel.canContinueStepOne,
                showChevron: true,
                action: { viewModel.goNext() }
            )
            .disabled(!viewModel.canContinueStepOne)
            .opacity(viewModel.canContinueStepOne ? 1.0 : 0.5)
        case 2:
            SurveyPrimaryButton(
                title: "Continue",
                isEnabled: viewModel.canContinueStepTwo,
                showChevron: true,
                action: { viewModel.goNext() }
            )
            .disabled(!viewModel.canContinueStepTwo)
            .opacity(viewModel.canContinueStepTwo ? 1.0 : 0.5)
        case 3:
            SurveyPrimaryButton(
                title: (source == .fromProfile || source.isFromProductDetail) ? "Complete Setup" : "Start Personalized Search",
                isEnabled: viewModel.canFinishSurvey,
                showChevron: true,
                action: { viewModel.onComplete?() }
            )
        default:
            EmptyView()
        }
    }

    private var topBar: some View {
        VStack(spacing: Design.space16) {
            HStack {
                SurveyBackButton(action: { viewModel.goBack() })
                Spacer()
            }
            .padding(.horizontal, Design.surveyHorizontalMargin)
            .padding(.top, Design.space8)

            SurveyProgressBar(currentStep: viewModel.currentStep, totalSteps: viewModel.totalSteps)
                .padding(.horizontal, Design.surveyHorizontalMargin)

            stepTitle
                .padding(.horizontal, Design.surveyHorizontalMargin)
                .padding(.bottom, Design.space8)
        }
        .background(Color.white)
    }

    private var stepTitle: some View {
        Text(stepTitleText)
            .font(.system(size: Design.surveyTitleFontSize, weight: .bold))
            .foregroundColor(Color(hex: "111827"))
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var stepTitleText: String {
        switch viewModel.currentStep {
        case 1: return "Tell us about yourself"
        case 2: return "What are your concerns?"
        case 3: return "Anything to avoid?"
        default: return ""
        }
    }

}

// MARK: - Previews

#Preview("iPhone SE") {
    NavigationStack {
        PersonalizedSurveyContainerView()
            .environmentObject(UserProfileStore())
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}

#Preview("iPhone 13 mini") {
    NavigationStack {
        PersonalizedSurveyContainerView()
            .environmentObject(UserProfileStore())
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
    }
}

#Preview("iPhone 15") {
    NavigationStack {
        PersonalizedSurveyContainerView()
            .environmentObject(UserProfileStore())
            .previewDevice(PreviewDevice(rawValue: "iPhone 15"))
    }
}

#Preview("iPhone 15 Pro Max") {
    NavigationStack {
        PersonalizedSurveyContainerView()
            .environmentObject(UserProfileStore())
            .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
    }
}

#Preview("Landscape") {
    NavigationStack {
        PersonalizedSurveyContainerView()
            .environmentObject(UserProfileStore())
            .previewDevice(PreviewDevice(rawValue: "iPhone 15"))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
