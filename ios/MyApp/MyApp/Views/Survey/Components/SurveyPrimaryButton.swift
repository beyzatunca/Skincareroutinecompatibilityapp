import SwiftUI

struct SurveyPrimaryButton: View {
    let title: String
    let isEnabled: Bool
    let showChevron: Bool
    let action: () -> Void

    private let mintGradient = LinearGradient(
        colors: [Color(hex: "C8E6E0"), Color(hex: "D8F0EC"), Color(hex: "F0F9F7")],
        startPoint: .leading,
        endPoint: .trailing
    )

    var body: some View {
        Button(action: action) {
            HStack(spacing: Design.space8) {
                Text(title)
                    .font(.system(size: Design.surveyBodyFontSize + 1, weight: .semibold))
                    .foregroundColor(isEnabled ? Color(hex: "111827") : Color(hex: "9CA3AF"))
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isEnabled ? Color(hex: "111827") : Color(hex: "9CA3AF"))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Design.surveyCTAVerticalPadding)
            .background(
                RoundedRectangle(cornerRadius: Design.surveyCTACornerRadius)
                    .fill(isEnabled ? AnyShapeStyle(mintGradient) : AnyShapeStyle(Color(hex: "F3F4F6")))
            )
            .shadow(color: isEnabled ? .black.opacity(0.08) : .clear, radius: 8, x: 0, y: 4)
        }
        .disabled(!isEnabled)
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        SurveyPrimaryButton(title: "Continue", isEnabled: true, showChevron: true, action: {})
        SurveyPrimaryButton(title: "Continue", isEnabled: false, showChevron: true, action: {})
    }
    .padding()
}
