import SwiftUI

struct PositiveEffectsPanel: View {
    let effects: [(title: String, description: String)]

    var body: some View {
        DetailPanelCard {
            VStack(alignment: .leading, spacing: Design.space12) {
                Text("Positive Effects")
                    .font(.system(size: Design.sectionTitleFontSize, weight: .semibold))
                    .foregroundColor(Color(hex: "111827"))
                VStack(alignment: .leading, spacing: Design.space8) {
                    ForEach(Array(effects.enumerated()), id: \.offset) { _, item in
                        HStack(alignment: .top, spacing: Design.space8) {
                            Circle()
                                .fill(Color(hex: "22C55E"))
                                .frame(width: 6, height: 6)
                                .padding(.top, 6)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                    .font(.system(size: Design.surveyBodyFontSize, weight: .semibold))
                                    .foregroundColor(Color(hex: "111827"))
                                Text(item.description)
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
    PositiveEffectsPanel(effects: [
        ("Exfoliating", "Removes dead skin cells for smoother texture"),
        ("Brightening", "Improves skin radiance and tone"),
        ("Anti-Aging", "Reduces fine lines and wrinkles")
    ])
    .padding()
}
