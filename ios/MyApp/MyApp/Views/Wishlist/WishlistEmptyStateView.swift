import SwiftUI

struct WishlistEmptyStateView: View {
    private let pinkBg = Color(hex: "FCE7F3")
    private let pinkCircle = Color(hex: "FBCFE8").opacity(0.6)

    var body: some View {
        VStack(spacing: Design.space24) {
            ZStack {
                Circle()
                    .fill(pinkCircle)
                    .frame(width: 120, height: 120)
                Image(systemName: "heart")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(Color(hex: "DB2777"))
            }
            .padding(.bottom, Design.space8)

            Text("Your wishlist is empty")
                .font(.system(size: Design.sectionTitleFontSize, weight: .bold))
                .foregroundColor(Color(hex: "111827"))
                .multilineTextAlignment(.center)

            Text("Add products to your wishlist by tapping the heart icon")
                .font(.system(size: Design.surveySubtextFontSize))
                .foregroundColor(Color(hex: "6B7280"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, Design.space32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Design.space32)
    }
}

#Preview {
    WishlistEmptyStateView()
        .frame(height: 400)
}
