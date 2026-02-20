import SwiftUI

/// Full-width rounded row for frequency options. Single-select; selected = mint background.
struct SelectableListRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    private static let mintBackground = Color(hex: "B8E6D5")
    private static let mintText = Color(hex: "047857")
    private static let borderGray = Color(hex: "E5E7EB")
    private static let textGray = Color(hex: "374151")
    private static let cornerRadius: CGFloat = 12

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                .foregroundColor(isSelected ? .white : Self.textGray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Design.space16)
                .padding(.vertical, Design.space12)
                .background(
                    RoundedRectangle(cornerRadius: Self.cornerRadius)
                        .fill(isSelected ? Self.mintBackground : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Self.cornerRadius)
                        .stroke(Self.borderGray, lineWidth: isSelected ? 0 : 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: Design.space12) {
        SelectableListRow(title: "Daily", isSelected: true) {}
        SelectableListRow(title: "2-3 times per week", isSelected: false) {}
    }
    .padding()
}
