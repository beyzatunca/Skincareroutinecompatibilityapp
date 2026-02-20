import SwiftUI

struct CameraAccessDeniedView: View {
    /// Pop to previous (e.g. Products). "Go Back" uses this.
    var onDismiss: () -> Void
    /// "Search Products Instead" — dismiss entire scan flow and return to Products.
    var onSearchInstead: () -> Void

    private let navy = Color(hex: "0F172A")
    private let mint = Color(hex: "9DD5CA")

    var body: some View {
        ZStack {
            navy
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                iconSection
                titleSection
                subtitleSection
                Spacer()
                buttonsSection
                    .padding(.bottom, Design.tabBarEstimatedHeight + Design.space24)
            }
            .padding(.horizontal, Design.contentHorizontalPadding)
        }
        .navigationBarHidden(true)
    }

    private var iconSection: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.4))
                .frame(width: 88, height: 88)
            Image(systemName: "camera.fill")
                .font(.system(size: 36))
                .foregroundColor(Color(hex: "EF4444"))
        }
        .padding(.bottom, Design.space24)
    }

    private var titleSection: some View {
        Text("Camera Access Denied")
            .font(.system(size: Design.headerTitleFontSize, weight: .bold))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.bottom, Design.space12)
    }

    private var subtitleSection: some View {
        Text("Please allow camera access in your browser settings\nto scan product barcodes.")
            .font(.system(size: Design.surveySubtextFontSize))
            .foregroundColor(Color.white.opacity(0.8))
            .multilineTextAlignment(.center)
            .padding(.bottom, Design.space32)
    }

    private var buttonsSection: some View {
        VStack(spacing: Design.space16) {
            Button(action: onSearchInstead) {
                Text("Search Products Instead")
                    .font(.system(size: Design.surveyBodyFontSize + 1, weight: .semibold))
                    .foregroundColor(Color(hex: "111827"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Design.surveyCTAVerticalPadding)
                    .background(
                        RoundedRectangle(cornerRadius: Design.surveyCTACornerRadius)
                            .fill(mint)
                    )
            }
            .buttonStyle(.plain)

            Button(action: onDismiss) {
                Text("Go Back")
                    .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    CameraAccessDeniedView(onDismiss: {}, onSearchInstead: {})
}
