import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search by name, brand, or active..."

    var body: some View {
        HStack(spacing: Design.space8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "9CA3AF"))
            TextField(placeholder, text: $text)
                .font(.system(size: Design.surveyBodyFontSize))
        }
        .padding(.horizontal, Design.space16)
        .frame(height: Design.productsSearchBarHeight)
        .background(Color(hex: "F3F4F6"))
        .clipShape(Capsule())
    }
}

#Preview {
    SearchBar(text: .constant(""))
        .padding()
}
