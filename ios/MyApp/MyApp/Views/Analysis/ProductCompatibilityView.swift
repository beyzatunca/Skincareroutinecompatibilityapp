import SwiftUI

/// Product Compatibility: check one product against current routine. Shown when user taps Check Compatibility from Discover Product Detail.
struct ProductCompatibilityView: View {
    @Binding var path: NavigationPath
    let productId: String
    @State private var showAddToRoutineSheet = false
    @State private var conflictsExpanded = false
    @State private var overlappingExpanded = false
    @State private var safeScheduleTimeOfDay: RoutineTimeOfDay = .pm
    @EnvironmentObject private var routineStore: RoutineStore
    @EnvironmentObject private var appState: AppState

    private var product: Product? {
        ProductsViewModel.mockProducts().first { $0.id == productId }
    }

    private let score: Int = 55
    private let cardCornerRadius: CGFloat = 16
    private let ctaBackground = Color(hex: "0D9488")
    private let ctaBottomPadding: CGFloat = 24

    private var verdictTier: VerdictTier {
        switch score {
        case 80...100: return .good
        case 40..<80: return .fair
        default: return .poor
        }
    }

    private var qualitativeLabel: String {
        switch score {
        case 80...100: return "Good"
        case 60..<80: return "Good"
        case 40..<60: return "Fair"
        default: return "Poor"
        }
    }

    private var qualitativeLabelColor: Color {
        switch verdictTier {
        case .good: return Color(hex: "059669")
        case .fair: return Color(hex: "D97706")
        case .poor: return Color(hex: "B91C1C")
        }
    }

    /// Recommended placement for Add to Routine sheet (PM • Alternate days).
    private var recommendedSelection: RoutineSelection {
        RoutineSelection(timeOfDay: .pm, frequency: .alternateDays)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: Design.space20) {
                headerSubtitle
                gaugeSection
                verdictCard
                avoidCard
                safeScheduleCard
            }
            .padding(.horizontal, Design.contentHorizontalPadding)
            .padding(.top, Design.space16)
            .padding(.bottom, Design.space24 + 80)
        }
        .background(Color.white)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            addToRoutineSafelyButton
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $showAddToRoutineSheet) {
            if let product = product {
                AddToRoutineSheetView(
                    product: product,
                    onConfirm: { selection in
                        routineStore.addOrUpdate(product: product, timeOfDay: selection.timeOfDay, frequency: selection.frequency)
                        showAddToRoutineSheet = false
                        appState.selectedTab = .home
                        appState.requestPopHomeToRoot = true
                        path = NavigationPath()
                        appState.showToast(type: .success, message: "Product added successfully")
                    },
                    onCancel: { showAddToRoutineSheet = false },
                    initialSelection: recommendedSelection
                )
                .presentationDetents([.fraction(0.62), .large])
                .presentationDragIndicator(.visible)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text("Product Compatibility")
                        .font(.system(size: Design.headerTitleFontSize, weight: .bold))
                        .foregroundColor(Color(hex: "111827"))
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    path = NavigationPath()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "374151"))
                }
            }
        }
    }

    // MARK: - 1) Header subtitle (under title) — screenshot: product name bold, then "with your current routine" gray
    private var headerSubtitle: some View {
        Group {
            if let product = product {
                VStack(alignment: .leading, spacing: 4) {
                    Text("For \(product.name)")
                        .font(.system(size: Design.surveyBodyFontSize + 1, weight: .bold))
                        .foregroundColor(Color(hex: "111827"))
                    Text("with your current routine")
                        .font(.system(size: Design.surveySubtextFontSize))
                        .foregroundColor(Color(hex: "6B7280"))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - 2) Gauge section — metin üstte, gösterge altta (Compatibility Result ile aynı)
    private var gaugeSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Önce açıklama metinleri
            VStack(alignment: .leading, spacing: Design.space8) {
                comparedAgainstText
                Text("Based on: ingredient conflicts, overlapping actives, irritation risk")
                    .font(.system(size: Design.surveyBodyFontSize))
                    .foregroundColor(Color(hex: "374151"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Metnin altında gösterge (Compatibility Result sayfasındaki ile aynı bileşen)
            CompatibilityScoreGaugeView(score: score)
                .frame(maxWidth: .infinity)
                .padding(.top, Design.space20)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Design.space8)
    }

    private var comparedAgainstText: some View {
        let n = routineStore.items.count
        let baseFont = Font.system(size: Design.surveyBodyFontSize)
        return (Text("Compared against ").font(baseFont) + Text("\(n)").font(.system(size: Design.surveyBodyFontSize, weight: .bold)) + Text(" products in your routine").font(baseFont))
            .foregroundColor(Color(hex: "374151"))
    }

    // MARK: - 3) Verdict card (product-specific)
    private var verdictCard: some View {
        HStack(alignment: .top, spacing: Design.space12) {
            Image(systemName: verdictTier.iconName)
                .font(.system(size: 22))
                .foregroundColor(verdictTier.iconColor)
            VStack(alignment: .leading, spacing: Design.space4) {
                Text(verdictTier.cardTitle)
                    .font(.system(size: Design.sectionTitleFontSize, weight: .bold))
                    .foregroundColor(Color(hex: "111827"))
                Text(verdictBodyText)
                    .font(.system(size: Design.surveyBodyFontSize))
                    .foregroundColor(Color(hex: "374151"))
            }
            Spacer(minLength: 8)
        }
        .padding(Design.space16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(verdictTier.backgroundColor)
        )
    }

    private var verdictBodyText: String {
        let name = product?.name ?? "This product"
        switch verdictTier {
        case .good:
            return "\(name) fits well with your current routine. You can add it following the safe schedule below."
        case .fair:
            return "\(name) may cause irritation when used with certain products in your routine. Follow the safe schedule below."
        case .poor:
            return "\(name) has a high risk of conflicts with your routine. Follow the safe schedule below and avoid combining with conflicting actives."
        }
    }

    // MARK: - 4) Avoid card (Conflicts / Overlapping expandable)
    private var avoidCard: some View {
        VStack(alignment: .leading, spacing: Design.space12) {
            HStack(spacing: Design.space8) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "EA580C"))
                Text("Avoid")
                    .font(.system(size: Design.sectionTitleFontSize, weight: .bold))
                    .foregroundColor(Color(hex: "111827"))
            }
            avoidRow(
                title: "Conflicts with your routine (2)",
                helper: "Don't use together in the same routine.",
                isExpanded: $conflictsExpanded,
                bullets: [
                    "Glycolic Acid (this product) × Differin (retinoid) — avoid same night",
                    "AHA (this product) × Retinol (Differin) — high irritation risk"
                ]
            )
            avoidRow(
                title: "Overlapping actives (1)",
                helper: "You're stacking too much of the same active.",
                isExpanded: $overlappingExpanded,
                bullets: [
                    "Acid stacking: you already use AHA (The Ordinary AHA) + this product adds another"
                ]
            )
        }
        .padding(Design.space16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(Color(hex: "FFF7ED"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .stroke(Color(hex: "FED7AA"), lineWidth: 1)
        )
    }

    private func avoidRow(title: String, helper: String, isExpanded: Binding<Bool>, bullets: [String]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) { isExpanded.wrappedValue.toggle() }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: Design.surveyBodyFontSize, weight: .semibold))
                            .foregroundColor(Color(hex: "111827"))
                        Text(helper)
                            .font(.system(size: Design.surveySubtextFontSize))
                            .foregroundColor(Color(hex: "6B7280"))
                    }
                    Spacer()
                    Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "6B7280"))
                }
                .padding(.vertical, Design.space8)
            }
            .buttonStyle(.plain)
            if isExpanded.wrappedValue {
                VStack(alignment: .leading, spacing: Design.space8) {
                    ForEach(bullets, id: \.self) { bullet in
                        HStack(alignment: .top, spacing: 6) {
                            Text("•")
                                .font(.system(size: Design.surveyBodyFontSize))
                                .foregroundColor(Color(hex: "374151"))
                            Text(bullet)
                                .font(.system(size: Design.surveyBodyFontSize))
                                .foregroundColor(Color(hex: "374151"))
                        }
                    }
                }
                .padding(.top, Design.space4)
                .padding(.bottom, Design.space12)
            }
        }
    }

    // MARK: - 5) Safe Schedule card
    private var safeScheduleCard: some View {
        VStack(alignment: .leading, spacing: Design.space16) {
            HStack(spacing: Design.space8) {
                Image(systemName: "calendar")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "2563EB"))
                    .frame(width: 40, height: 40)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: "DBEAFE")))
                Text("Your Safe Schedule")
                    .font(.system(size: Design.sectionTitleFontSize, weight: .bold))
                    .foregroundColor(Color(hex: "111827"))
            }
            SegmentedPillSelector(selection: $safeScheduleTimeOfDay)
            VStack(alignment: .leading, spacing: 6) {
                Text("Recommended placement: PM • Alternate days")
                    .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                    .foregroundColor(Color(hex: "374151"))
                Text("Avoid combining with: Retinol (same night)")
                    .font(.system(size: Design.surveySubtextFontSize))
                    .foregroundColor(Color(hex: "6B7280"))
            }
            .padding(.vertical, Design.space8)
            .padding(.horizontal, Design.space12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(hex: "E0F2FE").opacity(0.5)))
            HStack(spacing: Design.space12) {
                Text("1")
                    .font(.system(size: Design.surveySubtextFontSize, weight: .semibold))
                    .foregroundColor(Color(hex: "374151"))
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(Color(hex: "E0F2FE")))
                Text(product?.name ?? "Product")
                    .font(.system(size: Design.surveyBodyFontSize))
                    .foregroundColor(Color(hex: "111827"))
                Spacer()
            }
        }
        .padding(Design.space16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(Color(hex: "EFF6FF"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .stroke(Color(hex: "93C5FD"), lineWidth: 1)
        )
    }

    // MARK: - 6) CTA
    private var addToRoutineSafelyButton: some View {
        Button {
            if product != nil {
                showAddToRoutineSheet = true
            }
        } label: {
            Text("Add to Routine Safely")
                .font(.system(size: Design.surveyBodyFontSize, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Design.space16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ctaBackground)
                )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Design.contentHorizontalPadding)
        .padding(.top, Design.space12)
        .padding(.bottom, ctaBottomPadding)
        .background(Color.white)
    }
}

// MARK: - Verdict tier (Good / Fair / Poor)
private enum VerdictTier {
    case good
    case fair
    case poor

    var cardTitle: String {
        switch self {
        case .good: return "Looks Compatible"
        case .fair: return "Safe to Add with Caution"
        case .poor: return "High Risk with Your Routine"
        }
    }

    var iconName: String {
        switch self {
        case .good: return "checkmark.circle.fill"
        case .fair, .poor: return "exclamationmark.triangle.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .good: return Color(hex: "059669")
        case .fair: return Color(hex: "EA580C")
        case .poor: return Color(hex: "B91C1C")
        }
    }

    var backgroundColor: Color {
        switch self {
        case .good: return Color(hex: "ECFDF5")
        case .fair: return Color(hex: "FEF9C3")
        case .poor: return Color(hex: "FEF2F2")
        }
    }
}

#Preview {
    NavigationStack {
        ProductCompatibilityView(path: .constant(NavigationPath()), productId: "13")
            .environmentObject(RoutineStore())
            .environmentObject(AppState())
    }
}
