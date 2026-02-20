import SwiftUI

struct KeyActivesPanel: View {
    var product: Product?
    @State private var showFullIngredients = false

    private var keyActives: [String] {
        product?.tags.prefix(4).map { $0 } ?? []
    }

    private var fullIngredientList: [String] {
        if let list = product?.ingredients, !list.isEmpty { return list }
        return product?.tags ?? []
    }

    var body: some View {
        DetailPanelCard {
            VStack(alignment: .leading, spacing: Design.space12) {
                Text("Key Actives")
                    .font(.system(size: Design.sectionTitleFontSize, weight: .semibold))
                    .foregroundColor(Color(hex: "111827"))

                if !keyActives.isEmpty {
                    FlowLayout(spacing: Design.space8) {
                        ForEach(keyActives, id: \.self) { text in
                            KeyActivePill(text: text)
                        }
                    }
                } else {
                    Text("Key actives information")
                        .font(.system(size: Design.surveySubtextFontSize))
                        .foregroundColor(Color(hex: "6B7280"))
                }

                if let product = product {
                    Text(ingredientDescription(for: product))
                        .font(.system(size: Design.surveyBodyFontSize))
                        .foregroundColor(Color(hex: "374151"))

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showFullIngredients.toggle()
                        }
                    } label: {
                        Text(showFullIngredients ? "Hide full list" : "See full list of ingredients")
                            .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                            .foregroundColor(Color(hex: "2563EB"))
                    }
                    .buttonStyle(.plain)

                    if showFullIngredients, !fullIngredientList.isEmpty {
                        VStack(alignment: .leading, spacing: Design.space8) {
                            Text("Full ingredient list")
                                .font(.system(size: Design.surveySubtextFontSize, weight: .semibold))
                                .foregroundColor(Color(hex: "374151"))
                            Text(fullIngredientList.joined(separator: ", "))
                                .font(.system(size: Design.surveySubtextFontSize))
                                .foregroundColor(Color(hex: "6B7280"))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.top, Design.space4)
                    }
                }
            }
        }
    }

    private func ingredientDescription(for product: Product) -> String {
        if product.category == .sunscreen {
            return "Broad-spectrum sunscreen for daily protection."
        }
        if product.tags.contains(where: { $0.lowercased().contains("retinol") }) {
            return "Supports skin renewal and texture."
        }
        if product.tags.contains(where: { $0.lowercased().contains("vitamin c") }) {
            return "Antioxidant protection and brightening."
        }
        return "Formulated to support your skin goals."
    }
}

private struct KeyActivePill: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: Design.surveySubtextFontSize, weight: .medium))
            .foregroundColor(Color(hex: "0C4A6E"))
            .padding(.horizontal, Design.space12)
            .padding(.vertical, Design.space8)
            .background(
                RoundedRectangle(cornerRadius: Design.productDetailPillCornerRadius)
                    .fill(Color(hex: "E0F2FE"))
            )
            .fixedSize(horizontal: true, vertical: true)
    }
}

#Preview {
    KeyActivesPanel(product: nil)
        .padding()
}
