import SwiftUI

struct SurveyCheckboxRow: View {
    let title: String
    let subtitle: String?
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: subtitle != nil ? .top : .center, spacing: Design.space12) {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .font(.system(size: 22))
                    .foregroundColor(isOn ? Color(hex: "0D9488") : Color(hex: "D1D5DB"))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                        .foregroundColor(Color(hex: "111827"))
                        .multilineTextAlignment(.leading)
                    if let sub = subtitle, !sub.isEmpty {
                        Text(sub)
                            .font(.system(size: Design.surveySubtextFontSize))
                            .foregroundColor(Color(hex: "6B7280"))
                            .multilineTextAlignment(.leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 0)
            }
            .padding(Design.space16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "F9FAFB"))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {
        SurveyCheckboxRow(title: "I have sensitive skin prone to irritation", subtitle: nil, isOn: false, action: {})
        SurveyCheckboxRow(title: "I'm pregnant or planning to be", subtitle: "We'll avoid certain ingredients", isOn: true, action: {})
    }
    .padding()
}
