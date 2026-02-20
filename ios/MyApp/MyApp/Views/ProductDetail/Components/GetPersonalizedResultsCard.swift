import SwiftUI

struct GetPersonalizedResultsCard: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Design.space12) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 40, height: 40)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color(hex: "0D9488"))
                }
                VStack(alignment: .leading, spacing: Design.space4) {
                    Text("Get Personalized Results")
                        .font(.system(size: Design.sectionTitleFontSize, weight: .bold))
                        .foregroundColor(.white)
                    Text("See how this fits your skin type and routine concerns")
                        .font(.system(size: Design.surveySubtextFontSize))
                        .foregroundColor(.white.opacity(0.95))
                }
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(Design.space16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [Color(hex: "0D9488"), Color(hex: "14B8A6")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: Design.productDetailPanelCornerRadius))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    GetPersonalizedResultsCard(onTap: {})
        .padding()
}
