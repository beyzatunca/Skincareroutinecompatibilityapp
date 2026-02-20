import SwiftUI

struct MainTabView: View {
    @StateObject private var routineStore = RoutineStore()
    @StateObject private var appState = AppState()
    @StateObject private var userProfileStore = UserProfileStore()
    @StateObject private var wishlistStore = WishlistStore()
    /// Single path for home tab: survey and products push onto this stack.
    @State private var homePath = NavigationPath()
    /// Path for Discover tab stack (ProductsView root).
    @State private var discoverPath = NavigationPath()
    /// Hide tab bar when Product Detail (or other fullscreen) is pushed (Home/Profile).
    @State private var hideTabBar = false

    /// Discover: hide tab bar whenever stack has pushed views. Home/Profile: use hideTabBar from view callbacks.
    private var showTabBar: Bool {
        if appState.selectedTab == .discover {
            return discoverPath.isEmpty
        }
        return !hideTabBar
    }

    var body: some View {
        ZStack(alignment: .top) {
            tabContent
                .environmentObject(routineStore)
                .environmentObject(appState)
                .environmentObject(userProfileStore)
                .environmentObject(wishlistStore)
                .onChange(of: appState.requestPopHomeToRoot) { _, requested in
                    if requested {
                        homePath = NavigationPath()
                        appState.requestPopHomeToRoot = false
                    }
                }
                .onChange(of: appState.selectedTab) { _, newTab in
                    if newTab == .home {
                        homePath = NavigationPath()
                    }
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    if showTabBar {
                        BottomTabBar(selectedTab: $appState.selectedTab)
                            .zIndex(1)
                    } else {
                        Color.clear
                            .frame(height: 0)
                    }
                }

            if let toast = appState.toast {
                ToastBanner(toast: toast) {
                    appState.toast = nil
                }
                .padding(.top, Design.space12)
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
                .zIndex(100)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: appState.toast != nil)
    }

    @ViewBuilder
    private var tabContent: some View {
        Group {
            switch appState.selectedTab {
            case .home:
                NavigationStack(path: $homePath) {
                    HomeView(path: $homePath)
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case .survey:
                                PersonalizedSurveyContainerView(path: $homePath, source: .fromHome)
                            case .surveyFromProductDetail(let productId):
                                PersonalizedSurveyContainerView(path: $homePath, source: .fromProductDetail(productId: productId))
                            case .products(let personalized, let fromHome):
                                ProductsView(path: $homePath, personalized: personalized, fromHome: fromHome)
                            case .productDetail(let productId, let personalized, let source):
                                ProductDetailView(path: $homePath, productId: productId, personalized: personalized, source: source)
                                    .onAppear { hideTabBar = true }
                                    .onDisappear { hideTabBar = false }
                            case .skincareCoach(_):
                                EmptyView()
                            case .scan:
                                ScanEntryRouterView(path: $homePath)
                            case .routine:
                                RoutineView()
                            case .compatibility:
                                CompatibilityView(path: $homePath)
                                    .onAppear { hideTabBar = true }
                            case .compatibilityResults:
                                CompatibilityResultsView(path: $homePath)
                                    .onAppear { hideTabBar = true }
                                    .onDisappear { hideTabBar = false }
                            case .analyzingProductCompatibility(_):
                                EmptyView()
                            case .productCompatibility(_):
                                EmptyView()
                            }
                        }
                }
            case .discover:
                NavigationStack(path: $discoverPath) {
                    ProductsView(
                        path: $discoverPath,
                        personalized: userProfileStore.isSurveyCompleted,
                        fromHome: false
                    )
                    .id(userProfileStore.isSurveyCompleted)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .productDetail(let productId, let personalized, let source):
                            ProductDetailView(path: $discoverPath, productId: productId, personalized: personalized, source: source)
                                .onAppear { hideTabBar = true }
                                .onDisappear { hideTabBar = false }
                        case .scan:
                            ScanEntryRouterView(path: $discoverPath)
                        case .surveyFromProductDetail(let productId):
                            PersonalizedSurveyContainerView(path: $discoverPath, source: .fromProductDetail(productId: productId))
                        case .compatibility:
                            CompatibilityView(path: $discoverPath)
                                .onAppear { hideTabBar = true }
                                .onDisappear { hideTabBar = false }
                        case .compatibilityResults:
                            CompatibilityResultsView(path: $discoverPath)
                                .onAppear { hideTabBar = true }
                                .onDisappear { hideTabBar = false }
                        case .analyzingProductCompatibility(let productId):
                            CompatibilityView(path: $discoverPath, productId: productId)
                                .onAppear { hideTabBar = true }
                                .onDisappear { hideTabBar = false }
                        case .productCompatibility(let productId):
                            ProductCompatibilityView(path: $discoverPath, productId: productId)
                                .onAppear { hideTabBar = true }
                                .onDisappear { hideTabBar = false }
                        case .survey, .products, .skincareCoach, .routine:
                            EmptyView()
                        }
                    }
                }
            case .profile:
                ProfileView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MainTabView()
}
