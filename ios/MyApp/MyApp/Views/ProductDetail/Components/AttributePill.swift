import SwiftUI

struct AttributePill: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: Design.surveySubtextFontSize, weight: .medium))
            .foregroundColor(Color(hex: "6B7280"))
            .lineLimit(1)
            .padding(.horizontal, Design.space12)
            .padding(.vertical, Design.space8)
            .background(
                RoundedRectangle(cornerRadius: Design.productDetailPillCornerRadius)
                    .stroke(Color(hex: "D1D5DB"), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: Design.productDetailPillCornerRadius)
                            .fill(Color(hex: "F9FAFB"))
                    )
            )
            .fixedSize(horizontal: true, vertical: true)
    }
}

#Preview {
    HStack(spacing: Design.space8) {
        AttributePill(title: "SPF")
        AttributePill(title: "Alcohol-Free")
        AttributePill(title: "Vegan")
    }
    .padding()
}
