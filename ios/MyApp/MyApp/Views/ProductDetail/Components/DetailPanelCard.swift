import SwiftUI

/// Reusable rounded white card with subtle shadow for detail panels.
struct DetailPanelCard<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(Design.space20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Design.productDetailPanelCornerRadius)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: Design.productDetailPanelShadowRadius, x: 0, y: 2)
            )
    }
}

#Preview {
    DetailPanelCard {
        Text("Panel content")
            .font(.body)
    }
    .padding()
}
