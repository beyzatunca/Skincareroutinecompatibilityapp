import SwiftUI

struct ProductHeroImage: View {
    var body: some View {
        RoundedRectangle(cornerRadius: Design.productDetailHeroCornerRadius)
            .fill(Color(hex: "E5E7EB"))
            .aspectRatio(Design.productDetailHeroAspectRatio, contentMode: .fit)
            .overlay(
                Image(systemName: "photo")
                    .font(.system(size: 48))
                    .foregroundColor(Color(hex: "9CA3AF"))
            )
    }
}

#Preview {
    ProductHeroImage()
        .padding()
}
