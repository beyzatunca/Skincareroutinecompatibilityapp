import SwiftUI

struct YourProfileSummaryCard: View {
    let ageRange: SurveyAgeRange?
    let skinType: SurveySkinType?
    let concernsCount: Int
    let hasSensitiveSkin: Bool

    private let cardCornerRadius: CGFloat = 16
    private let dividerColor = Color(hex: "E5E7EB")

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: Design.space12) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "93C5FD"))
                        .frame(width: 44, height: 44)
                    Image(systemName: "person.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: Design.space4) {
                    Text("Your Profile")
                        .font(.system(size: Design.sectionTitleFontSize, weight: .bold))
                        .foregroundColor(Color(hex: "111827"))
                    Text("Profile complete")
                        .font(.system(size: Design.surveySubtextFontSize))
                        .foregroundColor(Color(hex: "6B7280"))
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, Design.contentHorizontalPadding)
            .padding(.top, Design.space16)
            .padding(.bottom, Design.space12)

            profileRow(label: "Skin Type", value: skinType?.rawValue ?? "—")
            divider
            profileRow(label: "Age Range", value: ageRange?.rawValue ?? "—")
            divider
            profileRow(label: "Main Concerns", value: "\(concernsCount) selected")
            divider
            profileRow(label: "Sensitive Skin", value: hasSensitiveSkin ? "Yes" : "No")
                .padding(.bottom, Design.space16)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }

    private func profileRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "374151"))
            Spacer(minLength: 8)
            Text(value)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "111827"))
        }
        .padding(.horizontal, Design.contentHorizontalPadding)
        .padding(.vertical, Design.space8)
    }

    private var divider: some View {
        Rectangle()
            .fill(dividerColor)
            .frame(height: 1)
            .padding(.leading, Design.contentHorizontalPadding)
    }
}

#Preview {
    YourProfileSummaryCard(
        ageRange: .age25_30,
        skinType: .combination,
        concernsCount: 1,
        hasSensitiveSkin: false
    )
    .padding()
}
