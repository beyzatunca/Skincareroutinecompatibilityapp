import SwiftUI

struct PriceBadge: View {
    let tier: PriceTier

    var body: some View {
        Text(tier.display)
            .font(.system(size: Design.surveySubtextFontSize, weight: .semibold))
            .foregroundColor(Color(hex: "6B7280"))
    }
}

#Preview {
    HStack(spacing: 8) {
        PriceBadge(tier: .budget)
        PriceBadge(tier: .mid)
        PriceBadge(tier: .premium)
    }
}
