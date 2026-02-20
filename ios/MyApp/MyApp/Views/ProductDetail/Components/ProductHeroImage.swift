import SwiftUI

/// Hero image for product detail: shows product image from asset name or placeholder.
struct ProductHeroImage: View {
    /// Asset catalog image name; nil shows placeholder.
    var imageName: String?

    var body: some View {
        Group {
            if let name = imageName {
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(Design.productDetailHeroAspectRatio, contentMode: .fill)
                    .clipped()
            } else {
                placeholder
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Design.productDetailHeroCornerRadius))
    }

    private var placeholder: some View {
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

#Preview("With image") {
    ProductHeroImage(imageName: "learn_1")
        .padding()
}

#Preview("Placeholder") {
    ProductHeroImage(imageName: nil)
        .padding()
}
