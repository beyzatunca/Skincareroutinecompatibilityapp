import SwiftUI

struct ProductsView: View {
    @Binding var path: NavigationPath
    let personalized: Bool
    let fromHome: Bool
    @StateObject private var viewModel: ProductsViewModel
    @State private var showWishlistSheet = false
    @State private var productForAddToRoutine: Product?
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var routineStore: RoutineStore
    @EnvironmentObject private var appState: AppState

    init(path: Binding<NavigationPath>, personalized: Bool, fromHome: Bool) {
        _path = path
        self.personalized = personalized
        self.fromHome = fromHome
        _viewModel = StateObject(wrappedValue: ProductsViewModel(personalized: personalized, fromHome: fromHome))
    }

    private var screenTitle: String {
        if fromHome { return "Add Your Products" }
        return "Discover Products"
    }

    var body: some View {
        VStack(spacing: 0) {
                ProductsTopBar(title: screenTitle, onBack: { dismiss() }, showBackButton: fromHome)

                ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Design.space16) {
                    SearchBar(text: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) { _, _ in viewModel.applySearchAndFilter() }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Design.space8) {
                            ForEach(ProductCategory.allCases) { category in
                                CategoryChip(
                                    title: category.rawValue,
                                    isSelected: viewModel.selectedCategory == category,
                                    action: {
                                        viewModel.selectedCategory = category
                                        viewModel.applySearchAndFilter()
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, Design.contentHorizontalPadding)
                    }
                    .padding(.horizontal, -Design.contentHorizontalPadding)

                    HStack(spacing: Design.space12) {
                        if fromHome {
                            ActionCard(
                                title: "Search by Barcode",
                                iconName: "barcode.viewfinder",
                                gradientColors: [Color(hex: "E9D5FF"), Color(hex: "F3E8FF")],
                                action: { path.append(AppRoute.scan) }
                            )
                            ActionCard(
                                title: "Search by Voice",
                                iconName: "mic.fill",
                                gradientColors: [Color(hex: "BFDBFE"), Color(hex: "93C5FD")],
                                action: { /* TODO: voice search */ }
                            )
                            ActionCard(
                                title: "Search by Photo",
                                iconName: "camera.fill",
                                gradientColors: [Color(hex: "99F6E4"), Color(hex: "5EEAD4")],
                                action: { /* TODO: photo search */ }
                            )
                        } else {
                            ActionCard(
                                title: "Scan Product",
                                iconName: "barcode.viewfinder",
                                gradientColors: [Color(hex: "E9D5FF"), Color(hex: "F3E8FF")],
                                action: { path.append(AppRoute.scan) }
                            )
                            ActionCard(
                                title: "Wishlist",
                                iconName: "heart.fill",
                                gradientColors: [Color(hex: "FCE7F3"), Color(hex: "FBCFE8")],
                                action: { showWishlistSheet = true }
                            )
                            if !personalized {
                                ActionCard(
                                    title: "Recent Scan",
                                    iconName: "viewfinder",
                                    gradientColors: [Color(hex: "99F6E4"), Color(hex: "5EEAD4")],
                                    action: { path.append(AppRoute.scan) }
                                )
                            }
                        }
                    }

                    if viewModel.personalized, !fromHome {
                        PersonalizedInfoCard(subtitle: viewModel.personalizedSummary)
                    }

                    Text("\(viewModel.filteredCount) products found")
                        .font(.system(size: Design.surveySubtextFontSize))
                        .foregroundColor(Color(hex: "6B7280"))

                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.products) { product in
                            ProductRow(
                                product: product,
                                onTap: fromHome ? {} : {
                                    path.append(AppRoute.productDetail(productId: product.id, personalized: personalized, source: .discover))
                                },
                                showAddButton: fromHome,
                                onAddTap: fromHome ? { productForAddToRoutine = product } : nil,
                                showPriceBadge: false
                            )
                        }
                    }
                }
                .padding(.horizontal, Design.contentHorizontalPadding)
                .padding(.top, Design.space16)
                .padding(.bottom, Design.tabBarEstimatedHeight + Design.space24)
            }
        }
        .background(Color(hex: "F9FAFB"))
        .navigationBarHidden(true)
        .sheet(isPresented: $showWishlistSheet) {
            WishlistSheetView()
                .presentationDetents([.fraction(0.72), .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.thinMaterial)
                .presentationCornerRadius(28)
        }
        .sheet(item: $productForAddToRoutine) { product in
            AddToRoutineSheetView(
                product: product,
                onConfirm: { selection in
                    routineStore.addOrUpdate(product: product, timeOfDay: selection.timeOfDay, frequency: selection.frequency)
                    productForAddToRoutine = nil
                    appState.selectedTab = .home
                    appState.requestPopHomeToRoot = true
                    appState.showToast(type: .success, message: "Product added successfully")
                },
                onCancel: { productForAddToRoutine = nil }
            )
            .presentationDetents([.fraction(0.62), .large])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview("iPhone SE") {
    NavigationStack {
        ProductsView(path: .constant(NavigationPath()), personalized: true, fromHome: true)
            .environmentObject(RoutineStore())
            .environmentObject(AppState())
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}

#Preview("iPhone 15 Pro Max") {
    NavigationStack {
        ProductsView(path: .constant(NavigationPath()), personalized: true, fromHome: true)
            .environmentObject(RoutineStore())
            .environmentObject(AppState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
    }
}

#Preview("Discover Products (non-personalized)") {
    NavigationStack {
        ProductsView(path: .constant(NavigationPath()), personalized: false, fromHome: false)
            .environmentObject(RoutineStore())
            .environmentObject(AppState())
    }
}
