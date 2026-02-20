import SwiftUI

struct FloatingActionsBar: View {
    var source: ProductDetailSource
    var isWishlisted: Bool = false
    var onPlus: (() -> Void)?
    var onCart: (() -> Void)?
    var onHeart: (() -> Void)?
    /// Discover only: triggers analysis loading then compatibility results.
    var onCheckCompatibility: (() -> Void)?

    private var showCartAndHeart: Bool { source == .discover }

    var body: some View {
        HStack(spacing: Design.space24) {
            if showCartAndHeart {
                floatingButton(icon: "plus", action: onPlus ?? {})
                floatingButton(icon: "cart", action: onCart ?? {})
                checkCompatibilityButton
                heartButton
            } else {
                Spacer(minLength: 0)
                floatingButton(icon: "plus", action: onPlus ?? {})
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, Design.space24)
        .padding(.vertical, Design.space12)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }

    private var checkCompatibilityButton: some View {
        Button(action: onCheckCompatibility ?? {}) {
            Image(systemName: "puzzlepiece.extension")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hex: "374151"))
                .frame(width: Design.productDetailFloatingButtonSize, height: Design.productDetailFloatingButtonSize)
                .background(Circle().fill(Color.white))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private var heartButton: some View {
        Button(action: onHeart ?? {}) {
            Image(systemName: isWishlisted ? "heart.fill" : "heart")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(isWishlisted ? Color(hex: "EC4899") : Color(hex: "374151"))
                .frame(width: Design.productDetailFloatingButtonSize, height: Design.productDetailFloatingButtonSize)
                .background(Circle().fill(Color.white))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private func floatingButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hex: "374151"))
                .frame(width: Design.productDetailFloatingButtonSize, height: Design.productDetailFloatingButtonSize)
                .background(Circle().fill(Color.white))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Discover") {
    VStack {
        Spacer()
        FloatingActionsBar(source: .discover)
    }
}

#Preview("Home Add Products") {
    VStack {
        Spacer()
        FloatingActionsBar(source: .homeAddProducts, onPlus: {})
    }
}
