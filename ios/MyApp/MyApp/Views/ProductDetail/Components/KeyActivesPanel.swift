import SwiftUI

struct KeyActivesPanel: View {
    var body: some View {
        DetailPanelCard {
            VStack(alignment: .leading, spacing: Design.space12) {
                Text("Key Actives")
                    .font(.system(size: Design.sectionTitleFontSize, weight: .semibold))
                    .foregroundColor(Color(hex: "111827"))

                HStack(spacing: Design.space8) {
                    KeyActivePill(text: "Avobenzone")
                    KeyActivePill(text: "Chemical UV filters")
                }

                Text("Lightweight sunscreen for daily protection")
                    .font(.system(size: Design.surveyBodyFontSize))
                    .foregroundColor(Color(hex: "374151"))

                Button(action: {}) {
                    Text("See full list of ingredients")
                        .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                        .foregroundColor(Color(hex: "2563EB"))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct KeyActivePill: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: Design.surveySubtextFontSize, weight: .medium))
            .foregroundColor(Color(hex: "0C4A6E"))
            .padding(.horizontal, Design.space12)
            .padding(.vertical, Design.space8)
            .background(
                RoundedRectangle(cornerRadius: Design.productDetailPillCornerRadius)
                    .fill(Color(hex: "E0F2FE"))
            )
            .fixedSize(horizontal: true, vertical: true)
    }
}

#Preview {
    KeyActivesPanel()
        .padding()
}
