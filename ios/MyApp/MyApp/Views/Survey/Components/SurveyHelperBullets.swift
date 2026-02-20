import SwiftUI

/// Bullet list with checkmark icons. Uses 8pt spacing system.
struct SurveyHelperBullets: View {
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: Design.space8) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: Design.space8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: Design.surveyBodyFontSize))
                        .foregroundColor(Color(hex: "9DD5CA"))
                    Text(item)
                        .font(.system(size: Design.surveySubtextFontSize))
                        .foregroundColor(Color(hex: "6B7280"))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SurveyHelperBullets(items: [
        "Share your age range",
        "Tell us your skin type",
        "Help us personalize for you"
    ])
    .padding()
}
