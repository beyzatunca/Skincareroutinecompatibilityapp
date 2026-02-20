import SwiftUI

struct HomeHeaderView: View {
    var onAddProducts: () -> Void
    var onCheckCompatibility: () -> Void

    var body: some View {
        ZStack {
            pastelGradientBackground
            VStack(spacing: 0) {
                titleSection
                    .padding(.top, Design.space48)
                    .padding(.bottom, Design.space32)
                actionButtons
                    .padding(.horizontal, Design.contentHorizontalPadding)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var pastelGradientBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "F0F9F4"),
                    Color(hex: "F8F3FA"),
                    Color(hex: "FDF2F8"),
                    Color(hex: "FFFAF5")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(0.98)
            RadialGradient(
                colors: [
                    Color(hex: "52A675").opacity(0.12),
                    Color.clear
                ],
                center: .init(x: 0.3, y: 0.2),
                startRadius: 0,
                endRadius: 400
            )
            RadialGradient(
                colors: [
                    Color(hex: "A855D8").opacity(0.10),
                    Color.clear
                ],
                center: .init(x: 0.7, y: 0.2),
                startRadius: 0,
                endRadius: 350
            )
            RadialGradient(
                colors: [
                    Color(hex: "F4A5BA").opacity(0.12),
                    Color.clear
                ],
                center: .init(x: 0.5, y: 0.6),
                startRadius: 0,
                endRadius: 300
            )
        }
        .ignoresSafeArea(edges: .top)
    }

    private var titleSection: some View {
        VStack(spacing: 4) {
            Text("Your Routine")
                .font(.system(size: Design.headerTitleFontSize, weight: .bold))
                .lineSpacing(2)
                .foregroundColor(Color(hex: "111827"))
            Text("Build your personalized skincare journey")
                .font(.system(size: Design.headerSubtitleFontSize))
                .foregroundColor(Color(hex: "374151"))
        }
    }

    private var actionButtons: some View {
        HStack(spacing: Design.space24) {
            HomeActionButton(
                icon: "plus",
                label: "Add Products",
                action: onAddProducts
            )
            HomeActionButton(
                icon: "puzzlepiece.extension",
                label: "Check Compatibility",
                action: onCheckCompatibility
            )
        }
    }
}

#Preview {
    HomeHeaderView(
        onAddProducts: {},
        onCheckCompatibility: {}
    )
    .frame(height: 380)
}
