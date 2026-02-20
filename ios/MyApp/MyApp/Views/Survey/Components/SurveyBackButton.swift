import SwiftUI

struct SurveyBackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                Text("Back")
                    .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
            }
            .foregroundColor(Color(hex: "374151"))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SurveyBackButton(action: {})
        .padding()
}
