import SwiftUI

struct ProductsTopBar: View {
    let title: String
    let onBack: () -> Void
    var showBackButton: Bool = true

    var body: some View {
        HStack {
            if showBackButton {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "111827"))
                        .frame(width: 44, height: 44)
                }
            } else {
                Color.clear.frame(width: 44, height: 44)
            }
            Spacer()
            Text(title)
                .font(.system(size: Design.sectionTitleFontSize, weight: .semibold))
                .foregroundColor(Color(hex: "111827"))
            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, Design.space8)
        .padding(.vertical, Design.space8)
        .background(Color.white)
    }
}

#Preview {
    ProductsTopBar(title: "Personalized Search", onBack: {})
}
