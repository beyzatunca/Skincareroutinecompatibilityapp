import SwiftUI

struct RecommendedFrequencyPanel: View {
    var body: some View {
        DetailPanelCard {
            VStack(alignment: .leading, spacing: Design.space16) {
                HStack(spacing: Design.space8) {
                    Image(systemName: "clock")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "6B7280"))
                    Text("Recommended Frequency")
                        .font(.system(size: Design.sectionTitleFontSize, weight: .bold))
                        .foregroundColor(Color(hex: "111827"))
                }

                VStack(spacing: Design.space12) {
                    FrequencyInnerRow(
                        title: "Standard Use",
                        text: "3–4 times per week (PM only) – e.g., Mon, Wed, Fri, Sat",
                        highlighted: true
                    )
                    FrequencyInnerRow(
                        title: "Sensitive Skin",
                        text: "1–2 times per week – e.g., Mon, Thu",
                        highlighted: false
                    )
                }
            }
        }
    }
}

private struct FrequencyInnerRow: View {
    let title: String
    let text: String
    let highlighted: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: Design.surveyBodyFontSize, weight: .semibold))
                .foregroundColor(Color(hex: "111827"))
            Text(text)
                .font(.system(size: Design.surveyBodyFontSize))
                .foregroundColor(Color(hex: "374151"))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Design.space16)
        .background(
            RoundedRectangle(cornerRadius: Design.productsCardCornerRadius)
                .fill(highlighted ? Color(hex: "E0F2FE") : Color(hex: "FAFAFA"))
                .overlay(
                    RoundedRectangle(cornerRadius: Design.productsCardCornerRadius)
                        .stroke(highlighted ? Color.clear : Color(hex: "E5E7EB"), lineWidth: 1)
                )
        )
    }
}

#Preview {
    RecommendedFrequencyPanel()
        .padding()
}
