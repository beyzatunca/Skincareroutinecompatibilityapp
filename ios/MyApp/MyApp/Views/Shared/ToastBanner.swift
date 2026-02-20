import SwiftUI

/// Top banner toast: success (green) or error (red) with icon + message, auto-dismiss ~2–2.5s.
struct ToastBanner: View {
    let toast: ToastState
    let onDismiss: () -> Void

    private static let cornerRadius: CGFloat = 15
    private static let dismissSuccessSeconds: Double = 2
    private static let dismissErrorSeconds: Double = 2.25

    private var isError: Bool { toast.type == .error }

    private var backgroundColor: Color {
        isError ? Color(hex: "FFEBEB") : Color(hex: "D1FAE5")
    }

    private var borderColor: Color {
        isError ? Color(hex: "F0C4C4") : Color.clear
    }

    private var iconName: String {
        isError ? "exclamationmark.circle.fill" : "checkmark.circle.fill"
    }

    private var contentColor: Color {
        isError ? Color(hex: "B91C1C") : Color(hex: "047857")
    }

    private var dismissSeconds: Double {
        isError ? Self.dismissErrorSeconds : Self.dismissSuccessSeconds
    }

    var body: some View {
        HStack(spacing: Design.space12) {
            Image(systemName: iconName)
                .font(.system(size: 22))
                .foregroundColor(contentColor)
            Text(toast.message)
                .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                .foregroundColor(contentColor)
            Spacer(minLength: 8)
        }
        .padding(.horizontal, Design.space16)
        .padding(.vertical, Design.space12)
        .background(
            RoundedRectangle(cornerRadius: Self.cornerRadius)
                .fill(backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Self.cornerRadius)
                .stroke(borderColor, lineWidth: isError ? 1 : 0)
        )
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
        .padding(.horizontal, Design.contentHorizontalPadding)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + dismissSeconds) {
                onDismiss()
            }
        }
    }
}

#Preview("Success") {
    VStack {
        ToastBanner(toast: ToastState(message: "Product added successfully", style: .success), onDismiss: {})
        Spacer()
    }
    .padding(.top, 50)
}

#Preview("Error") {
    VStack {
        ToastBanner(toast: ToastState(type: .error, message: "Please add products first"), onDismiss: {})
        Spacer()
    }
    .padding(.top, 50)
}
