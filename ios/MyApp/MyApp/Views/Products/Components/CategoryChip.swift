import SwiftUI

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    private let mint = Color(hex: "C8E6E0")
    private let mintBorder = Color(hex: "9DD5CA")
    private let strokeGray = Color(hex: "E5E7EB")

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: Design.surveySubtextFontSize, weight: .medium))
                .foregroundColor(isSelected ? Color(hex: "1F2937") : Color(hex: "4B5563"))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .padding(.horizontal, Design.space16)
                .frame(height: Design.productsChipHeight)
                .background(
                    Capsule()
                        .fill(isSelected ? mint : Color(hex: "F3F4F6"))
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? mintBorder : strokeGray, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: 8) {
        CategoryChip(title: "All", isSelected: true, action: {})
        CategoryChip(title: "Cleanser", isSelected: false, action: {})
    }
    .padding()
}
