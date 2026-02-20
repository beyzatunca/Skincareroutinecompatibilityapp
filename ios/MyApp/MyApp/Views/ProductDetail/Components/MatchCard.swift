import SwiftUI

private let matchChipBackground = Color(hex: "ECFEFF")
private let matchAccent = Color(hex: "0D9488")

/// Chip-style box: check icon + "Perfect Match for your concerns".
struct PerfectMatchChip: View {
    var body: some View {
        HStack(spacing: Design.space12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 22))
                .foregroundColor(matchAccent)
            Text("Perfect Match for your concerns")
                .font(.system(size: Design.surveyBodyFontSize, weight: .semibold))
                .foregroundColor(Color(hex: "111827"))
            Spacer(minLength: 0)
        }
        .padding(.horizontal, Design.space16)
        .padding(.vertical, Design.space12)
        .background(
            RoundedRectangle(cornerRadius: Design.productDetailMatchCardCornerRadius)
                .fill(matchChipBackground)
        )
    }
}

/// Description box: same color as chip, bullet list.
struct MatchDescriptionBox: View {
    let bullets: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: Design.space8) {
            ForEach(bullets, id: \.self) { bullet in
                HStack(alignment: .top, spacing: Design.space8) {
                    Circle()
                        .fill(matchAccent)
                        .frame(width: 6, height: 6)
                        .padding(.top, 6)
                    Text(bullet)
                        .font(.system(size: Design.surveyBodyFontSize))
                        .foregroundColor(Color(hex: "374151"))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Design.space16)
        .background(
            RoundedRectangle(cornerRadius: Design.productDetailMatchCardCornerRadius)
                .fill(matchChipBackground)
        )
    }
}

/// Legacy full card; kept for preview. Prefer PerfectMatchChip + MatchDescriptionBox.
struct MatchCard: View {
    let title: String
    let subtitle: String
    let bullets: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: Design.space12) {
            HStack(alignment: .top, spacing: Design.space12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(matchAccent)
                VStack(alignment: .leading, spacing: Design.space4) {
                    Text(title)
                        .font(.system(size: Design.sectionTitleFontSize, weight: .semibold))
                        .foregroundColor(Color(hex: "111827"))
                    Text(subtitle)
                        .font(.system(size: Design.surveySubtextFontSize))
                        .foregroundColor(Color(hex: "6B7280"))
                }
                Spacer(minLength: 0)
            }
            VStack(alignment: .leading, spacing: Design.space8) {
                ForEach(bullets, id: \.self) { bullet in
                    HStack(alignment: .top, spacing: Design.space8) {
                        Circle()
                            .fill(matchAccent)
                            .frame(width: 6, height: 6)
                            .padding(.top, 6)
                        Text(bullet)
                            .font(.system(size: Design.surveyBodyFontSize))
                            .foregroundColor(Color(hex: "374151"))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(Design.space20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Design.productDetailMatchCardCornerRadius)
                .fill(matchChipBackground)
        )
    }
}

#Preview("Chip + Description") {
    VStack(spacing: 12) {
        PerfectMatchChip()
        MatchDescriptionBox(bullets: ["Oil Control: Lightweight formula won't clog pores or feel greasy"])
    }
    .padding()
}

#Preview("Legacy MatchCard") {
    MatchCard(
        title: "Perfect Match for Your Concerns",
        subtitle: "Based on your Combination skin type",
        bullets: ["Oil Control: Lightweight formula won't clog pores or feel greasy"]
    )
    .padding()
}
