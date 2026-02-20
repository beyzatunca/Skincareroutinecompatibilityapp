import SwiftUI

struct IngredientTagPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(Color(hex: "6B7280"))
            .padding(.horizontal, Design.space8)
            .padding(.vertical, Design.space4)
            .background(Color(hex: "F3F4F6"))
            .clipShape(Capsule())
    }
}

#Preview {
    HStack(spacing: 6) {
        IngredientTagPill(text: "AHA")
        IngredientTagPill(text: "Glycolic Acid")
    }
}
