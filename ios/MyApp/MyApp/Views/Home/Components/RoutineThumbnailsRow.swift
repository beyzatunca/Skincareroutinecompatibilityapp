import SwiftUI

/// Up to 3 circles: product thumbnails first (placeholder if no image), then "+" placeholders.
/// Circles use an overlapping stack (avatar-style); leftmost appears on top.
struct RoutineThumbnailsRow: View {
    let products: [Product]

    private static let size: CGFloat = Design.routineCardPlusButtonSizeFixed
    private static let borderColor = Color.white
    private static let shadowColor = Color.black.opacity(0.25)
    private static let shadowRadius: CGFloat = 10
    private static let plusColor = Color(hex: "9CA3AF")
    /// Overlap between circles (pts); negative HStack spacing.
    private static let overlap: CGFloat = 12

    var body: some View {
        HStack(spacing: -Self.overlap) {
            ForEach(0..<3, id: \.self) { index in
                Group {
                    if index < products.count {
                        productThumbnail(products[index])
                    } else {
                        plusPlaceholder
                    }
                }
                .zIndex(Double(3 - 1 - index))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func productThumbnail(_ product: Product) -> some View {
        ZStack {
            Circle()
                .fill(Color(hex: "F3F4F6"))
                .frame(width: Self.size, height: Self.size)
                .overlay(
                    Circle()
                        .stroke(Self.borderColor, lineWidth: 1)
                )
                .shadow(color: Self.shadowColor, radius: 4, x: 0, y: 3)
            if let name = product.imageName {
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .frame(width: Self.size, height: Self.size)
                    .clipShape(Circle())
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "9CA3AF"))
            }
        }
    }

    private var plusPlaceholder: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: Self.size, height: Self.size)
                .shadow(color: Self.shadowColor, radius: 10, x: 0, y: 6)
                .shadow(color: Color.black.opacity(0.18), radius: 4, x: 0, y: 3)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Self.plusColor)
        }
    }

}

#Preview {
    VStack {
        RoutineThumbnailsRow(products: [
            Product(id: "1", name: "Serum", brand: "X", priceTier: .mid, tags: [], category: .serum, matchScore: 0.9, imageName: nil, amazonUrl: nil)
        ])
        RoutineThumbnailsRow(products: [])
    }
    .padding()
}
