import SwiftUI

struct RoutineCardView: View {
    let iconName: String
    let title: String
    let subtitle: String
    let accentColor: String
    let gradientEnd: String
    /// Products to show as thumbnails (up to 3). Empty = show three "+" placeholders.
    var products: [Product] = []
    var action: (() -> Void)? = nil

    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    RadialGradient(
                        colors: [
                            Color(hex: gradientEnd).opacity(0.3),
                            Color.clear
                        ],
                        center: .topTrailing,
                        startRadius: 0,
                        endRadius: 80
                    )
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .opacity(0.6)

                    HStack(alignment: .center, spacing: Design.space8) {
                        Image(systemName: iconName)
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: accentColor))
                            .frame(width: 24, height: 24, alignment: .center)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(title)
                                .font(.system(size: Design.routineCardTitleFontSize, weight: .bold))
                                .foregroundColor(Color(hex: "111827"))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            Text(subtitle)
                                .font(.system(size: Design.routineCardSubtitleFontSize))
                                .foregroundColor(Color(hex: "4B5563"))
                                .lineLimit(1)
                        }
                        .frame(minWidth: 52, alignment: .leading)
                        Spacer(minLength: 4)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(hex: "9CA3AF"))
                            .frame(width: 24, height: 24, alignment: .center)
                            .contentShape(Rectangle())
                    }
                    .padding(Design.space20)
                }

                RoutineThumbnailsRow(products: products)
                    .padding(.top, Design.space16)
                    .padding(.horizontal, Design.space20)
                    .padding(.bottom, Design.space20)
            }
            .background(
                RoundedRectangle(cornerRadius: Design.routineCardCornerRadius)
                    .fill(Color.white.opacity(0.98))
            )
            .overlay(
                RoundedRectangle(cornerRadius: Design.routineCardCornerRadius)
                    .stroke(Color(hex: "F3F4F6"), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
        }
    }
}

#Preview {
    HStack(spacing: Design.space16) {
        RoutineCardView(
            iconName: "sun.max.fill",
            title: "Morning",
            subtitle: "AM Routine",
            accentColor: "D97706",
            gradientEnd: "FCD34D"
        )
        RoutineCardView(
            iconName: "moon.fill",
            title: "Evening",
            subtitle: "PM Routine",
            accentColor: "2563EB",
            gradientEnd: "93C5FD"
        )
    }
    .padding()
}
