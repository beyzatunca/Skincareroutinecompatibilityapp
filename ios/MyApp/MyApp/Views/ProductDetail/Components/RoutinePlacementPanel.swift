import SwiftUI

/// Fixed order of routine steps. All are always shown; the step matching the product is highlighted.
private let routineStepOrder: [String] = [
    "Makeup Removal",
    "Cleansing",
    "Exfoliation",
    "Toning",
    "Treatment",
    "Treatment Mask",
    "Eye Care",
    "Moisturizing",
    "Protection"
]

struct RoutinePlacementPanel: View {
    var product: Product?

    /// Maps product category to the step name used in routineStepOrder.
    private var currentStepName: String? {
        guard let category = product?.category else { return nil }
        switch category {
        case .cleanser: return "Cleansing"
        case .toner: return "Toning"
        case .serum: return "Treatment"
        case .moisturizer: return "Moisturizing"
        case .sunscreen: return "Protection"
        case .mask: return "Treatment Mask"
        case .other: return "Treatment"
        case .all: return nil
        }
    }

    var body: some View {
        DetailPanelCard {
            VStack(alignment: .leading, spacing: Design.space12) {
                Text("Routine Placement")
                    .font(.system(size: Design.sectionTitleFontSize, weight: .semibold))
                    .foregroundColor(Color(hex: "111827"))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Design.space8) {
                        ForEach(Array(routineStepOrder.enumerated()), id: \.offset) { index, stepName in
                            if index > 0 {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "9CA3AF"))
                            }
                            RoutineStepPill(
                                text: stepName,
                                isHighlighted: stepName == currentStepName
                            )
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
    }
}

private struct RoutineStepPill: View {
    let text: String
    var isHighlighted: Bool = false

    var body: some View {
        Text(text)
            .font(.system(size: Design.surveySubtextFontSize, weight: .medium))
            .foregroundColor(isHighlighted ? Color(hex: "0C4A6E") : Color(hex: "374151"))
            .padding(.horizontal, Design.space12)
            .padding(.vertical, Design.space8)
            .background(
                RoundedRectangle(cornerRadius: Design.productDetailPillCornerRadius)
                    .fill(isHighlighted ? Color(hex: "E0F2FE") : Color(hex: "F3F4F6"))
                    .overlay(
                        RoundedRectangle(cornerRadius: Design.productDetailPillCornerRadius)
                            .stroke(Color(hex: "E5E7EB"), lineWidth: isHighlighted ? 0 : 1)
                    )
            )
            .fixedSize(horizontal: true, vertical: true)
    }
}

#Preview {
    RoutinePlacementPanel(product: nil)
        .padding()
}
