import SwiftUI

struct PersonalizedInfoCard: View {
    let subtitle: String

    var body: some View {
        HStack(alignment: .top, spacing: Design.space12) {
            Image(systemName: "sparkles")
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "A855D8"))
            VStack(alignment: .leading, spacing: Design.space4) {
                Text("Personalized for You")
                    .font(.system(size: Design.surveySectionTitleFontSize, weight: .semibold))
                    .foregroundColor(Color(hex: "111827"))
                Text(subtitle)
                    .font(.system(size: Design.surveySubtextFontSize))
                    .foregroundColor(Color(hex: "6B7280"))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(Design.space16)
        .background(
            RoundedRectangle(cornerRadius: Design.productsCardCornerRadius)
                .fill(Color(hex: "FAF5FF"))
                .overlay(
                    RoundedRectangle(cornerRadius: Design.productsCardCornerRadius)
                        .stroke(Color(hex: "E9D5FF"), lineWidth: 1)
                )
        )
    }
}

#Preview {
    PersonalizedInfoCard(subtitle: "Products ranked by match with your Normal skin and Large pores concerns")
        .padding()
}
