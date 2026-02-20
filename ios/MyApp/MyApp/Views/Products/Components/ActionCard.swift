import SwiftUI

struct ActionCard: View {
    let title: String
    let iconName: String
    let gradientColors: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Design.space8) {
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.95))
                Text(title)
                    .font(.system(size: Design.surveySectionTitleFontSize, weight: .semibold))
                    .foregroundColor(Color(hex: "111827"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Design.space16)
            .background(
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: Design.productsCardCornerRadius))
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: 12) {
        ActionCard(
            title: "Scan Product",
            iconName: "barcode.viewfinder",
            gradientColors: [Color(hex: "E9D5FF"), Color(hex: "F3E8FF")],
            action: {}
        )
        ActionCard(
            title: "Wishlist",
            iconName: "heart.fill",
            gradientColors: [Color(hex: "FCE7F3"), Color(hex: "FBCFE8")],
            action: {}
        )
    }
    .padding()
}
