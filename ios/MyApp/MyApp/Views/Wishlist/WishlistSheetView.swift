import SwiftUI

struct WishlistSheetView: View {
    @EnvironmentObject private var wishlistStore: WishlistStore

    var body: some View {
        VStack(spacing: 0) {
            headerRow
                .padding(.horizontal, Design.contentHorizontalPadding)
                .padding(.top, Design.space16)
                .padding(.bottom, Design.space24)

            if wishlistStore.items.isEmpty {
                WishlistEmptyStateView()
            } else {
                wishlistList
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "F9FAFB"))
    }

    private var headerRow: some View {
        HStack {
            Text("My Wishlist")
                .font(.system(size: Design.headerTitleFontSize, weight: .bold))
                .foregroundColor(Color(hex: "111827"))
            Spacer()
            Text("\(wishlistStore.items.count) items")
                .font(.system(size: Design.surveySubtextFontSize, weight: .medium))
                .foregroundColor(Color(hex: "9D174D"))
                .padding(.horizontal, Design.space12)
                .padding(.vertical, Design.space8)
                .background(
                    Capsule()
                        .fill(Color(hex: "FCE7F3"))
                )
        }
    }

    private var wishlistList: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(spacing: Design.space12) {
                ForEach(wishlistStore.items) { product in
                    HStack(alignment: .center, spacing: Design.space12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name)
                                .font(.system(size: Design.surveyBodyFontSize, weight: .semibold))
                                .foregroundColor(Color(hex: "111827"))
                            Text(product.brand)
                                .font(.system(size: Design.surveySubtextFontSize))
                                .foregroundColor(Color(hex: "6B7280"))
                        }
                        Spacer(minLength: 8)
                    }
                    .padding(Design.space16)
                    .background(
                        RoundedRectangle(cornerRadius: Design.routineCardCornerRadius)
                            .fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Design.routineCardCornerRadius)
                            .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, Design.contentHorizontalPadding)
            .padding(.bottom, Design.space24)
        }
    }
}

#Preview {
    WishlistSheetView()
        .environmentObject(WishlistStore())
        .frame(height: 500)
}
