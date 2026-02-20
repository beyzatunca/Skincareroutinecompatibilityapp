import SwiftUI

/// Analysis Results screen: Risk Summary (red), Avoid (orange) accordion, Your Safe Schedule (blue), sticky CTA.
struct CompatibilityResultsView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = CompatibilityResultsViewModel()

    private static let cardCornerRadius: CGFloat = 15
    private static let iconSize: CGFloat = 22
    private static let ctaCornerRadius: CGFloat = 16
    private static let ctaBottomPadding: CGFloat = 24
    private static let mintBackground = Color(hex: "B8E6D5")
    private static let mintText = Color(hex: "047857")

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: Design.space20) {
                CompatibilityScoreGaugeView(score: appState.lastCompatibilityScore)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Design.space8)

                riskSummaryCard
                avoidCard
                safeScheduleCard
            }
            .padding(.horizontal, Design.contentHorizontalPadding)
            .padding(.top, Design.space16)
            .padding(.bottom, Design.space24)
        }
        .background(Color.white)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            ctaButton
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Score reflects "Your barrier is under risk" content: Fair (40–60) so gauge matches the risk message.
            appState.setCompatibilityCheckCompleted(true, score: 45)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Compatibility Result")
                    .font(.system(size: Design.headerTitleFontSize, weight: .bold))
                    .foregroundColor(Color(hex: "111827"))
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

    // MARK: - 1) Risk Summary Card (red)
    private var riskSummaryCard: some View {
        HStack(alignment: .top, spacing: Design.space12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: Self.iconSize))
                .foregroundColor(Color(hex: "B91C1C"))
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "FEE2E2"))
                )
            VStack(alignment: .leading, spacing: Design.space4) {
                Text("Your Barrier is Under Risk")
                    .font(.system(size: Design.sectionTitleFontSize, weight: .bold))
                    .foregroundColor(Color(hex: "111827"))
                Text("Your routine has minor conflicts that should be addressed for optimal results and skin health.")
                    .font(.system(size: Design.surveyBodyFontSize))
                    .foregroundColor(Color(hex: "374151"))
            }
            Spacer(minLength: 8)
        }
        .padding(Design.space16)
        .background(
            RoundedRectangle(cornerRadius: Self.cardCornerRadius)
                .fill(Color(hex: "FEF2F2"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Self.cardCornerRadius)
                .stroke(Color(hex: "FECACA"), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }

    // MARK: - 2) Avoid Card (orange)
    private var avoidCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: Design.space8) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "EA580C"))
                Text("Avoid")
                    .font(.system(size: Design.sectionTitleFontSize, weight: .bold))
                    .foregroundColor(Color(hex: "111827"))
            }
            .padding(.bottom, Design.space16)

            accordionRow(
                title: "Ingredient Conflicts (1)",
                isExpanded: $viewModel.isIngredientConflictsExpanded,
                description: "Don't use together in the same routine.",
                expandedContent: {
                    VStack(alignment: .leading, spacing: Design.space8) {
                        HStack(alignment: .top, spacing: Design.space8) {
                            Rectangle()
                                .fill(Color(hex: "EA580C"))
                                .frame(width: 3)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Product A × Product B")
                                    .font(.system(size: Design.surveyBodyFontSize, weight: .bold))
                                    .foregroundColor(Color(hex: "111827"))
                                Text("Conflicting actives: Retinoid + Benzoyl Peroxide")
                                    .font(.system(size: Design.surveySubtextFontSize))
                                    .foregroundColor(Color(hex: "EA580C"))
                                Text("Increased irritation / reduced tolerance")
                                    .font(.system(size: Design.surveySubtextFontSize))
                                    .foregroundColor(Color(hex: "6B7280"))
                            }
                        }
                    }
                }
            )

            accordionRow(
                title: "Skin Barrier Damage (3)",
                isExpanded: $viewModel.isSkinBarrierDamageExpanded,
                description: "You're stacking too much of the same active.",
                expandedContent: {
                    VStack(alignment: .leading, spacing: Design.space12) {
                        conflictLine(active: "AHA/BHA (acids)", foundIn: "Product A, Product D, Product F")
                        conflictLine(active: "Retinoids", foundIn: "Product C, Product E")
                        conflictLine(active: "Vitamin C", foundIn: "Product B, Product G")
                    }
                }
            )
        }
        .padding(Design.space16)
        .background(
            RoundedRectangle(cornerRadius: Self.cardCornerRadius)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Self.cardCornerRadius)
                .stroke(Color(hex: "FED7AA"), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }

    private func accordionRow<Content: View>(
        title: String,
        isExpanded: Binding<Bool>,
        description: String,
        @ViewBuilder expandedContent: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.wrappedValue.toggle()
                }
            } label: {
                HStack {
                    Text(title)
                        .font(.system(size: Design.surveyBodyFontSize, weight: .semibold))
                        .foregroundColor(Color(hex: "111827"))
                    Spacer()
                    Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "6B7280"))
                }
                .padding(.vertical, Design.space8)
            }
            .buttonStyle(.plain)

            if !isExpanded.wrappedValue {
                Text(description)
                    .font(.system(size: Design.surveySubtextFontSize))
                    .foregroundColor(Color(hex: "6B7280"))
                    .padding(.bottom, Design.space12)
            }

            if isExpanded.wrappedValue {
                expandedContent()
                    .padding(.top, Design.space4)
                    .padding(.bottom, Design.space12)
            }
        }
    }

    private func conflictLine(active: String, foundIn: String) -> some View {
        HStack(alignment: .top, spacing: Design.space8) {
            Rectangle()
                .fill(Color(hex: "EA580C"))
                .frame(width: 3)
            VStack(alignment: .leading, spacing: 2) {
                Text(active)
                    .font(.system(size: Design.surveyBodyFontSize, weight: .bold))
                    .foregroundColor(Color(hex: "111827"))
                Text("found in: \(foundIn)")
                    .font(.system(size: Design.surveySubtextFontSize))
                    .foregroundColor(Color(hex: "6B7280"))
            }
        }
    }

    // MARK: - 3) Your Safe Schedule Card (blue)
    private var safeScheduleCard: some View {
        VStack(alignment: .leading, spacing: Design.space16) {
            HStack(spacing: Design.space8) {
                Image(systemName: "calendar")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "2563EB"))
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "DBEAFE"))
                    )
                Text("Your Safe Schedule")
                    .font(.system(size: Design.sectionTitleFontSize, weight: .bold))
                    .foregroundColor(Color(hex: "111827"))
            }

            HStack(spacing: Design.space12) {
                ForEach(CompatibilityResultsViewModel.ScheduleSegment.allCases, id: \.self) { segment in
                    schedulePill(segment: segment)
                }
            }

            VStack(alignment: .leading, spacing: Design.space12) {
                ForEach(Array(viewModel.currentScheduleProducts.enumerated()), id: \.offset) { index, name in
                    HStack(spacing: Design.space12) {
                        Text("\(index + 1)")
                            .font(.system(size: Design.surveySubtextFontSize, weight: .semibold))
                            .foregroundColor(Color(hex: "374151"))
                            .frame(width: 24, height: 24)
                            .background(Circle().fill(Color(hex: "E0F2FE")))
                        Text(name)
                            .font(.system(size: Design.surveyBodyFontSize))
                            .foregroundColor(Color(hex: "111827"))
                        Spacer()
                    }
                }
            }
        }
        .padding(Design.space16)
        .background(
            RoundedRectangle(cornerRadius: Self.cardCornerRadius)
                .fill(Color(hex: "EFF6FF"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Self.cardCornerRadius)
                .stroke(Color(hex: "93C5FD"), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }

    private func schedulePill(segment: CompatibilityResultsViewModel.ScheduleSegment) -> some View {
        let isSelected = viewModel.selectedSegment == segment
        return Button {
            viewModel.selectedSegment = segment
        } label: {
            Text(segment.rawValue)
                .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                .foregroundColor(isSelected ? .white : Color(hex: "374151"))
                .padding(.horizontal, Design.space20)
                .padding(.vertical, Design.space12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color(hex: "0D9488") : Color(hex: "E5E7EB"))
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - CTA
    private var ctaButton: some View {
        Button {
            appState.setCompatibilityCheckCompleted(true, score: 85)
            appState.selectedTab = .home
            path = NavigationPath()
        } label: {
            Text("Adjust My Routine")
                .font(.system(size: Design.surveyBodyFontSize, weight: .bold))
                .foregroundColor(Self.mintText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Design.surveyCTAVerticalPadding)
                .background(
                    RoundedRectangle(cornerRadius: Self.ctaCornerRadius)
                        .fill(Self.mintBackground)
                )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Design.contentHorizontalPadding)
        .padding(.top, Design.space12)
        .padding(.bottom, Self.ctaBottomPadding)
        .background(Color.white)
    }
}

#Preview {
    NavigationStack {
        CompatibilityResultsView(path: .constant(NavigationPath()))
            .environmentObject(AppState())
    }
}
