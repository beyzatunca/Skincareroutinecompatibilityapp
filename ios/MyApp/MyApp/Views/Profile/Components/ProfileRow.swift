import SwiftUI

struct ProfileRow: View {
    let title: String
    let iconName: String
    let iconBackgroundColor: Color
    let isDestructive: Bool
    let showChevron: Bool
    let action: () -> Void

    private let iconCircleSize: CGFloat = 44

    init(
        title: String,
        iconName: String,
        iconBackgroundColor: Color,
        isDestructive: Bool = false,
        showChevron: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.iconBackgroundColor = iconBackgroundColor
        self.isDestructive = isDestructive
        self.showChevron = showChevron
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: Design.space12) {
                ZStack {
                    Circle()
                        .fill(iconBackgroundColor)
                        .frame(width: iconCircleSize, height: iconCircleSize)
                    Image(systemName: iconName)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(isDestructive ? Color(hex: "DC2626") : Color(hex: "111827"))
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 8)
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "9CA3AF"))
                }
            }
            .padding(.horizontal, Design.contentHorizontalPadding)
            .padding(.vertical, Design.space12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 0) {
        ProfileRow(title: "Complete Profile Setup", iconName: "person.circle.fill", iconBackgroundColor: Color(hex: "93C5FD"), action: {})
        ProfileRow(title: "Delete Profile", iconName: "trash.fill", iconBackgroundColor: Color(hex: "FCA5A5"), isDestructive: true, showChevron: false, action: {})
    }
}
