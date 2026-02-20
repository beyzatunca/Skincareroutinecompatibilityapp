import SwiftUI

struct RoutinePlacementPanel: View {
    var body: some View {
        DetailPanelCard {
            VStack(alignment: .leading, spacing: Design.space12) {
                Text("Routine Placement")
                    .font(.system(size: Design.sectionTitleFontSize, weight: .semibold))
                    .foregroundColor(Color(hex: "111827"))

                Text("Protection Step")
                    .font(.system(size: Design.surveySubtextFontSize, weight: .medium))
                    .foregroundColor(Color(hex: "0C4A6E"))
                    .padding(.horizontal, Design.space12)
                    .padding(.vertical, Design.space8)
                    .background(
                        RoundedRectangle(cornerRadius: Design.productDetailPillCornerRadius)
                            .fill(Color(hex: "E0F2FE"))
                    )
                    .fixedSize(horizontal: true, vertical: true)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Design.space8) {
                        RoutineStepPill(text: "Makeup Removal")
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "9CA3AF"))
                        RoutineStepPill(text: "Cleansing")
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "9CA3AF"))
                        RoutineStepPill(text: "Toning")
                    }
                    .padding(.horizontal, 2)
                }

                Text("Swipe to see the full routine flow →")
                    .font(.system(size: Design.surveySubtextFontSize))
                    .foregroundColor(Color(hex: "9CA3AF"))
            }
        }
    }
}

private struct RoutineStepPill: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: Design.surveySubtextFontSize, weight: .medium))
            .foregroundColor(Color(hex: "374151"))
            .padding(.horizontal, Design.space12)
            .padding(.vertical, Design.space8)
            .background(
                RoundedRectangle(cornerRadius: Design.productDetailPillCornerRadius)
                    .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: Design.productDetailPillCornerRadius)
                            .fill(Color(hex: "F3F4F6"))
                    )
            )
            .fixedSize(horizontal: true, vertical: true)
    }
}

#Preview {
    RoutinePlacementPanel()
        .padding()
}
