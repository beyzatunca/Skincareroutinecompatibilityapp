import SwiftUI

/// Large rounded mint "Add Product" style button with subtle shadow.
struct PrimaryCTAButton: View {
    let title: String
    let action: () -> Void

    private static let mintBackground = Color(hex: "B8E6D5")
    private static let mintText = Color(hex: "047857")
    private static let cornerRadius: CGFloat = 14

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: Design.surveyBodyFontSize + 1, weight: .semibold))
                .foregroundColor(Self.mintText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Design.surveyCTAVerticalPadding)
                .background(
                    RoundedRectangle(cornerRadius: Self.cornerRadius)
                        .fill(Self.mintBackground)
                )
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PrimaryCTAButton(title: "Add Product") {}
        .padding()
}
