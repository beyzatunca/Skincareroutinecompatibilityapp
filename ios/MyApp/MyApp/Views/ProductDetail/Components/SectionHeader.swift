import SwiftUI

struct ProductDetailSectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: Design.sectionTitleFontSize, weight: .semibold))
            .foregroundColor(Color(hex: "111827"))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ProductDetailSectionHeader(title: "Benefits for Your Combination Skin")
        .padding()
}
