import SwiftUI

struct InfoCard: View {
    let title: String
    let bodyText: String

    var body: some View {
        VStack(alignment: .leading, spacing: Design.space8) {
            Text(title)
                .font(.system(size: Design.sectionTitleFontSize, weight: .bold))
                .foregroundColor(Color(hex: "1D4ED8"))
            Text(bodyText)
                .font(.system(size: Design.surveyBodyFontSize))
                .foregroundColor(Color(hex: "475569"))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Design.space16)
        .background(Color(hex: "EFF6FF"))
        .clipShape(RoundedRectangle(cornerRadius: Design.productsCardCornerRadius))
    }
}

#Preview {
    InfoCard(
        title: "Your Data is Private",
        bodyText: "All your skincare data is stored locally on your device. We don't collect, share, or sell any of your personal information."
    )
    .padding()
}
