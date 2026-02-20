import SwiftUI

struct ProductDetailView: View {
    @Binding var path: NavigationPath
    let productId: String
    let personalized: Bool
    let source: ProductDetailSource
    @StateObject private var viewModel: ProductDetailViewModel
    @State private var showSkincareCoach = false
    @State private var showAddToRoutineSheet = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var routineStore: RoutineStore
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var userProfileStore: UserProfileStore
    @EnvironmentObject private var wishlistStore: WishlistStore

    private var isPersonalized: Bool { userProfileStore.isSurveyCompleted }

    init(path: Binding<NavigationPath>, productId: String, personalized: Bool, source: ProductDetailSource) {
        _path = path
        self.productId = productId
        self.personalized = personalized
        self.source = source
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(productId: productId, personalized: personalized))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    topBar
                    whiteContent
                }
            }
            .background(Color(hex: "F9FAFB"))
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .tabBar)

            floatingOverlays
        }
        .fullScreenCover(isPresented: $showSkincareCoach) {
            SkincareCoachView(productId: productId, onDismiss: { showSkincareCoach = false })
        }
        .sheet(isPresented: $showAddToRoutineSheet) {
            AddToRoutineSheetView(product: viewModel.product, onConfirm: { selection in
                guard let product = viewModel.product else {
                    showAddToRoutineSheet = false
                    return
                }
                routineStore.addOrUpdate(product: product, timeOfDay: selection.timeOfDay, frequency: selection.frequency)
                showAddToRoutineSheet = false
                appState.selectedTab = .home
                appState.requestPopHomeToRoot = true
                appState.toast = ToastState(message: "Product added successfully", style: .success)
            }, onCancel: {
                showAddToRoutineSheet = false
            })
            .presentationDetents([.fraction(0.62), .large])
            .presentationDragIndicator(.visible)
        }
    }

    private var benefitForYourSkinCard: some View {
        DetailPanelCard {
            VStack(alignment: .leading, spacing: Design.space12) {
                Text("Benefit for your skin")
                    .font(.system(size: Design.sectionTitleFontSize, weight: .semibold))
                    .foregroundColor(Color(hex: "111827"))
                VStack(alignment: .leading, spacing: Design.space8) {
                    ForEach(viewModel.placeholderBenefits, id: \.self) { benefit in
                        HStack(alignment: .top, spacing: Design.space8) {
                            Circle()
                                .fill(Color(hex: "0D9488"))
                                .frame(width: 6, height: 6)
                                .padding(.top, 6)
                            Text(benefit)
                                .font(.system(size: Design.surveyBodyFontSize))
                                .foregroundColor(Color(hex: "374151"))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(hex: "111827"))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .padding(.horizontal, Design.space8)
        .padding(.top, Design.space8)
        .padding(.bottom, Design.space12)
        .background(Color.white)
    }

    private var whiteContent: some View {
        VStack(alignment: .leading, spacing: Design.space20) {
            ProductHeroImage(imageName: viewModel.product?.imageName)
                .padding(.horizontal, Design.contentHorizontalPadding)
                .padding(.top, Design.space8)

            VStack(alignment: .leading, spacing: Design.space8) {
                if let product = viewModel.product {
                    Text(product.brand)
                        .font(.system(size: Design.surveySubtextFontSize))
                        .foregroundColor(Color(hex: "6B7280"))
                    Text(product.name)
                        .font(.system(size: Design.headerTitleFontSize, weight: .bold))
                        .foregroundColor(Color(hex: "111827"))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.horizontal, Design.contentHorizontalPadding)

            FlowLayout(spacing: Design.space8) {
                ForEach(viewModel.attributePills, id: \.self) { pill in
                    AttributePill(title: pill)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, Design.contentHorizontalPadding)

            if isPersonalized {
                if viewModel.showMatchCard {
                    PerfectMatchChip()
                        .padding(.horizontal, Design.contentHorizontalPadding)
                    MatchDescriptionBox(bullets: viewModel.matchBullets)
                        .padding(.horizontal, Design.contentHorizontalPadding)
                    benefitForYourSkinCard
                        .padding(.horizontal, Design.contentHorizontalPadding)
                }
            } else {
                GetPersonalizedResultsCard {
                    path.append(AppRoute.surveyFromProductDetail(productId: productId))
                }
                .padding(.horizontal, Design.contentHorizontalPadding)

                PositiveEffectsPanel(effects: viewModel.positiveEffects)
                    .padding(.horizontal, Design.contentHorizontalPadding)

                NegativeEffectsPanel(effects: viewModel.negativeEffects)
                    .padding(.horizontal, Design.contentHorizontalPadding)
            }

            HowToUsePanel()
                .padding(.horizontal, Design.contentHorizontalPadding)

            KeyActivesPanel(product: viewModel.product)
                .padding(.horizontal, Design.contentHorizontalPadding)

            RecommendedFrequencyPanel()
                .padding(.horizontal, Design.contentHorizontalPadding)

            if isPersonalized {
                RoutinePlacementPanel(product: viewModel.product)
                    .padding(.horizontal, Design.contentHorizontalPadding)
            }
            Spacer().frame(height: 160)
        }
        .background(Color.white)
    }

    private static let floatingFooterBottomPadding: CGFloat = 18
    private static let floatingFooterHeight: CGFloat = 56 + 24
    /// Chatbot sabit konumu: bar genişliğinden bağımsız, her iki source'ta aynı.
    private static let chatbotTrailing: CGFloat = 24
    private static let chatbotBottom: CGFloat = 96

    private var floatingOverlays: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                Spacer()
                FloatingActionsBar(
                    source: source,
                    isWishlisted: viewModel.product.map { wishlistStore.isWishlisted($0) } ?? false,
                    onPlus: { showAddToRoutineSheet = true },
                    onCart: {
                        guard let product = viewModel.product else { return }
                        if product.amazonUrl == nil || product.amazonUrl?.isEmpty == true {
                            appState.showToast(type: .error, message: "Amazon link not available")
                        } else {
                            AmazonLinkOpener.openAmazon(for: product)
                        }
                    },
                    onHeart: {
                        guard let product = viewModel.product else { return }
                        wishlistStore.toggle(product)
                        appState.showToast(
                            type: .success,
                            message: wishlistStore.isWishlisted(product) ? "Added wishlist" : "Removed wishlist"
                        )
                    },
                    onCheckCompatibility: source == .discover ? {
                        if !routineStore.hasAnyProducts {
                            appState.showToast(type: .error, message: "Please add products first")
                            return
                        }
                        path.append(AppRoute.analyzingProductCompatibility(productId: productId))
                    } : nil
                )
                .padding(.bottom, Self.floatingFooterBottomPadding)
                .zIndex(100)
            }
            .frame(maxWidth: .infinity)
            .zIndex(50)

            AIChatbotButton(productId: productId, onTap: {
                showSkincareCoach = true
            }, showNotificationDot: true)
            .padding(.trailing, Self.chatbotTrailing)
            .padding(.bottom, Self.chatbotBottom)
            .zIndex(101)
        }
        .allowsHitTesting(true)
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(path: .constant(NavigationPath()), productId: "13", personalized: true, source: .discover)
            .environmentObject(RoutineStore())
            .environmentObject(AppState())
            .environmentObject(UserProfileStore())
            .environmentObject(WishlistStore())
    }
}
