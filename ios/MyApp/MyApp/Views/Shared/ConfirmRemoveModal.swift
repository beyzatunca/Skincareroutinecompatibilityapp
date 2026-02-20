import SwiftUI

/// Reusable confirmation modal: dimmed backdrop + centered white card with title, message, Cancel and destructive action button.
struct ConfirmRemoveModal: View {
    let title: String
    let message: String
    /// Label for the destructive (red) button, e.g. "Remove" or "Delete".
    var destructiveButtonTitle: String = "Remove"
    let onCancel: () -> Void
    let onRemove: () -> Void

    private static let cardCornerRadius: CGFloat = 28
    private static let buttonHeight: CGFloat = 54
    private static let buttonSpacing: CGFloat = 14
    private static let removeRed = Color(hex: "FF3B30")
    private static let cancelGray = Color(hex: "E5E7EB")
    private static let animationDuration: Double = 0.22

    var body: some View {
        ZStack {
            backdrop
            card
        }
        .transition(.opacity)
    }

    private var backdrop: some View {
        Color.black.opacity(0.35)
            .ignoresSafeArea()
            .onTapGesture { }
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: Design.space24) {
            Text(title)
                .font(.system(size: Design.headerTitleFontSize, weight: .bold))
                .foregroundColor(Color(hex: "111827"))
            Text(message)
                .font(.system(size: Design.surveyBodyFontSize))
                .foregroundColor(Color(hex: "6B7280"))
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: Self.buttonSpacing) {
                cancelButton
                removeButton
            }
        }
        .padding(Design.space24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Self.cardCornerRadius)
                .fill(Color.white)
        )
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        .padding(.horizontal, Design.contentHorizontalPadding)
        .scaleEffect(1)
        .opacity(1)
    }

    private var cancelButton: some View {
        Button(action: onCancel) {
            Text("Cancel")
                .font(.system(size: Design.surveyBodyFontSize + 1, weight: .semibold))
                .foregroundColor(Color(hex: "374151"))
                .frame(maxWidth: .infinity)
                .frame(height: Self.buttonHeight)
                .background(
                    Capsule().fill(Self.cancelGray)
                )
        }
        .buttonStyle(.plain)
    }

    private var removeButton: some View {
        Button(action: onRemove) {
            Text(destructiveButtonTitle)
                .font(.system(size: Design.surveyBodyFontSize + 1, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: Self.buttonHeight)
                .background(
                    Capsule().fill(Self.removeRed)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
        ConfirmRemoveModal(
            title: "Remove Product?",
            message: "Are you sure you want to remove this product from your routine?",
            onCancel: {},
            onRemove: {}
        )
    }
}
