import SwiftUI

struct SurveyProgressBar: View {
    let currentStep: Int
    let totalSteps: Int

    private let mint = Color(hex: "9DD5CA")
    private let inactiveGray = Color(hex: "E5E7EB")

    var body: some View {
        GeometryReader { geo in
            let segmentWidth = (geo.size.width - CGFloat(totalSteps - 1) * Design.space8) / CGFloat(totalSteps)
            HStack(spacing: Design.space8) {
                ForEach(1...totalSteps, id: \.self) { step in
                    RoundedRectangle(cornerRadius: Design.surveyProgressBarHeight / 2)
                        .fill(step <= currentStep ? mint : inactiveGray)
                        .frame(width: max(0, segmentWidth), height: Design.surveyProgressBarHeight)
                }
            }
        }
        .frame(height: Design.surveyProgressBarHeight)
        .animation(.easeInOut(duration: 0.25), value: currentStep)
    }
}

#Preview {
    VStack(spacing: 20) {
        SurveyProgressBar(currentStep: 1, totalSteps: 3)
        SurveyProgressBar(currentStep: 2, totalSteps: 3)
        SurveyProgressBar(currentStep: 3, totalSteps: 3)
    }
    .padding()
}
