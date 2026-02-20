import SwiftUI

struct NegativeEffectsPanel: View {
    let effects: [(title: String, active: String)]

    var body: some View {
        DetailPanelCard {
            VStack(alignment: .leading, spacing: Design.space12) {
                Text("Negative Effects")
                    .font(.system(size: Design.sectionTitleFontSize, weight: .semibold))
                    .foregroundColor(Color(hex: "111827"))
                VStack(alignment: .leading, spacing: Design.space8) {
                    ForEach(Array(effects.enumerated()), id: \.offset) { _, item in
                        HStack(alignment: .top, spacing: Design.space8) {
                            Circle()
                                .fill(Color(hex: "EF4444"))
                                .frame(width: 6, height: 6)
                                .padding(.top, 6)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                    .font(.system(size: Design.surveyBodyFontSize, weight: .semibold))
                                    .foregroundColor(Color(hex: "111827"))
                                Text(item.active)
                                    .font(.system(size: Design.surveySubtextFontSize))
                                    .foregroundColor(Color(hex: "6B7280"))
                            }
                            Spacer(minLength: 0)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NegativeEffectsPanel(effects: [
        ("Skin Irritation", "Active: Glycolic Acid (AHA)"),
        ("Sun Sensitivity", "Active: Glycolic Acid")
    ])
    .padding()
}
