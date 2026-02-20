import SwiftUI

struct HomeView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject private var routineStore: RoutineStore
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var userProfileStore: UserProfileStore
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                headerSection
                contentSection
            }
            .padding(.bottom, Design.tabBarEstimatedHeight + Design.space16)
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }

    private var headerSection: some View {
        HomeHeaderView(
            onAddProducts: {
                if userProfileStore.isSurveyCompleted {
                    path.append(AppRoute.products(personalized: true, fromHome: true))
                } else {
                    path.append(AppRoute.survey)
                }
            },
            onCheckCompatibility: {
                if !routineStore.hasAnyProducts {
                    appState.showToast(type: .error, message: "Please add products first")
                    return
                }
                path.append(AppRoute.compatibility)
            },
            showCompatibilityGauge: appState.hasCompletedCompatibilityCheck,
            compatibilityScore: appState.lastCompatibilityScore
        )
        .frame(height: headerHeight)
    }

    private var headerHeight: CGFloat {
        let screen = UIScreen.main.bounds.height
        if appState.hasCompletedCompatibilityCheck {
            return min(screen * 0.52, 440)
        }
        return min(screen * 0.42, 380)
    }

    private var contentSection: some View {
        VStack(spacing: 0) {
            if hasRoutineProducts {
                whiteContentBackground
            }
            learnSection
        }
        .padding(.bottom, Design.space24)
        .background(Color.white)
    }

    private var whiteContentBackground: some View {
        VStack(spacing: 0) {
            routineCards
        }
        .padding(.horizontal, Design.contentHorizontalPadding)
        .padding(.top, Design.space24)
        .padding(.bottom, Design.space24)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "ECFDF5").opacity(0.4),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: Design.routineCardCornerRadius,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: Design.routineCardCornerRadius
            )
        )
    }

    /// Rutinde en az bir ürün varsa Morning/Evening kartları tıklanabilir ve Manage My Products açılır.
    private var hasRoutineProducts: Bool {
        !routineStore.items.isEmpty
    }

    private var routineCards: some View {
        GeometryReader { geo in
            let cardWidth = (geo.size.width - Design.space16) / 2
            HStack(spacing: Design.space16) {
                NavigationLink(value: AppRoute.routine) {
                    routineCard(
                        iconName: "sun.max.fill",
                        title: "Morning",
                        subtitle: "AM Routine",
                        accentColor: "D97706",
                        gradientEnd: "FCD34D",
                        products: routineStore.morningProducts,
                        cardWidth: cardWidth
                    )
                }
                .buttonStyle(.plain)
                NavigationLink(value: AppRoute.routine) {
                    routineCard(
                        iconName: "moon.fill",
                        title: "Evening",
                        subtitle: "PM Routine",
                        accentColor: "2563EB",
                        gradientEnd: "93C5FD",
                        products: routineStore.eveningProducts,
                        cardWidth: cardWidth
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .frame(minHeight: Design.routineCardMinHeight)
    }

    private func routineCard(
        iconName: String,
        title: String,
        subtitle: String,
        accentColor: String,
        gradientEnd: String,
        products: [Product],
        cardWidth: CGFloat
    ) -> some View {
        RoutineCardView(
            iconName: iconName,
            title: title,
            subtitle: subtitle,
            accentColor: accentColor,
            gradientEnd: gradientEnd,
            products: products
        )
        .frame(width: cardWidth)
        .frame(minHeight: Design.routineCardMinHeight)
    }

    private var learnSection: some View {
        LearnDiscoverCarousel(
            cards: LearnCard.dummyCards,
            onCardTap: { _ in }
        )
        .padding(.top, Design.space16)
    }
}

#Preview("iPhone 15 Pro") {
    NavigationStack {
        HomeView(path: .constant(NavigationPath()))
            .environmentObject(RoutineStore())
            .environmentObject(AppState())
    }
    .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
}

#Preview("iPhone SE") {
    NavigationStack {
        HomeView(path: .constant(NavigationPath()))
            .environmentObject(RoutineStore())
            .environmentObject(AppState())
    }
    .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
}
