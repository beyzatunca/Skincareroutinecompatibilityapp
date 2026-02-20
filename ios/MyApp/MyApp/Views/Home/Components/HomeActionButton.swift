import SwiftUI

struct HomeActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Design.space8) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.85))
                        .frame(width: Design.actionButtonSize, height: Design.actionButtonSize)
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)
                        .shadow(color: .black.opacity(0.18), radius: 4, x: 0, y: 3)
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color(hex: "111827"))
                }
                Text(label)
                    .font(.system(size: Design.actionLabelFontSize, weight: .medium))
                    .foregroundColor(Color(hex: "111827"))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: Design.space24) {
        HomeActionButton(icon: "plus", label: "Add Products", action: {})
        HomeActionButton(icon: "puzzlepiece.extension", label: "Check Compatibility", action: {})
    }
    .padding()
}
