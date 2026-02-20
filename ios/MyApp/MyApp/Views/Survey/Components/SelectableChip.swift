import SwiftUI

struct SelectableChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    private let mint = Color(hex: "C8E6E0")
    private let mintBorder = Color(hex: "9DD5CA")
    private let strokeGray = Color(hex: "E5E7EB")

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                .foregroundColor(isSelected ? Color(hex: "1F2937") : Color(hex: "4B5563"))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .padding(.horizontal, Design.space16)
                .frame(height: Design.surveyChipHeight)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: Design.surveyChipHeight / 2)
                        .fill(isSelected ? mint : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Design.surveyChipHeight / 2)
                        .stroke(isSelected ? mintBorder : strokeGray, lineWidth: 1.5)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: 12) {
        SelectableChip(title: "Dry", isSelected: false, action: {})
        SelectableChip(title: "Oily", isSelected: true, action: {})
    }
    .padding()
}
