import SwiftUI

struct ProductRow: View {
    let product: Product
    let onTap: () -> Void
    /// When true, shows a trailing + button that calls onAddTap. Used on "Add Your Products" screen.
    var showAddButton: Bool = false
    var onAddTap: (() -> Void)?
    /// When false, price badge (e.g. $) is hidden. Used on "Add Your Products" screen.
    var showPriceBadge: Bool = true

    private var productThumbnail: some View {
        Group {
            if let name = product.imageName {
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .frame(width: Design.productsThumbnailSize, height: Design.productsThumbnailSize)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: Design.space8)
                    .fill(Color.gray.opacity(0.2))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Design.space8))
    }

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: Design.productsRowPadding) {
                productThumbnail
                    .frame(width: Design.productsThumbnailSize, height: Design.productsThumbnailSize)

                VStack(alignment: .leading, spacing: Design.space4) {
                    Text(product.name)
                        .font(.system(size: Design.surveyBodyFontSize, weight: .semibold))
                        .foregroundColor(Color(hex: "111827"))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Text(product.brand)
                        .font(.system(size: Design.surveySubtextFontSize))
                        .foregroundColor(Color(hex: "6B7280"))
                        .lineLimit(1)
                    FlowLayout(spacing: Design.space4) {
                        ForEach(product.tags.prefix(4), id: \.self) { tag in
                            IngredientTagPill(text: tag)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if showPriceBadge {
                    PriceBadge(tier: product.priceTier)
                }

                if showAddButton, let onAddTap = onAddTap {
                    Button(action: onAddTap) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color(hex: "059669"))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Design.productsRowPadding)
            .background(Color.white)
        }
        .buttonStyle(.plain)
    }
}

/// Simple flow layout for wrapping pills (wrapping HStack). Uses consistent horizontal and vertical spacing.
struct FlowLayout: Layout {
    var horizontalSpacing: CGFloat = 8
    var verticalSpacing: CGFloat = 8

    init(spacing: CGFloat = 8) {
        self.horizontalSpacing = spacing
        self.verticalSpacing = spacing
    }

    init(horizontalSpacing: CGFloat = 8, verticalSpacing: CGFloat = 8) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, point) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        // Use proposed width when available; fallback so narrow screens (e.g. iPhone SE) still wrap
        let proposedWidth = proposal.width ?? .infinity
        let maxWidth: CGFloat = proposedWidth.isFinite && proposedWidth > 0 ? proposedWidth : 320
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            let itemWidth = size.width
            let itemHeight = size.height
            if x + itemWidth > maxWidth && x > 0 {
                x = 0
                y += rowHeight + verticalSpacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, itemHeight)
            maxX = max(maxX, x + itemWidth)
            x += itemWidth + horizontalSpacing
        }
        let totalHeight = y + rowHeight
        let usedWidth = min(maxX, maxWidth)
        return (CGSize(width: usedWidth, height: totalHeight), positions)
    }
}

#Preview {
    ProductRow(
        product: Product(id: "1", name: "C E Ferulic", brand: "SkinCeuticals", priceTier: .premium, tags: ["Vitamin C", "AHA"], category: .serum, matchScore: 0.95, imageName: nil, amazonUrl: nil),
        onTap: {}
    )
    .padding()
}
