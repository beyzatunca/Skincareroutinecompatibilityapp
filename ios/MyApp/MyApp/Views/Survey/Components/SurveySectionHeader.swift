import SwiftUI

struct SurveySectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: Design.surveySectionTitleFontSize, weight: .semibold))
            .foregroundColor(Color(hex: "111827"))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SurveySectionHeader(title: "Skin Type")
        .padding()
}
