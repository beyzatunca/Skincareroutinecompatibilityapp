import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var userProfileStore: UserProfileStore
    @EnvironmentObject private var routineStore: RoutineStore
    @EnvironmentObject private var wishlistStore: WishlistStore
    @EnvironmentObject private var appState: AppState
    @State private var showSurvey = false
    @State private var showPreferencesPlaceholder = false
    @State private var showPrivacyPolicyPlaceholder = false
    @State private var showDeleteProfileConfirmation = false
    @State private var showClearDataConfirmation = false

    private let cardCornerRadius: CGFloat = 16
    private let dividerColor = Color(hex: "E5E7EB")

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 0) {
                header
                Spacer().frame(height: Design.space24)

                if userProfileStore.isSurveyCompleted {
                    YourProfileSummaryCard(
                        ageRange: userProfileStore.ageRange,
                        skinType: userProfileStore.skinType,
                        concernsCount: userProfileStore.concerns.count,
                        hasSensitiveSkin: userProfileStore.hasSensitiveSkin
                    )
                    .padding(.horizontal, Design.contentHorizontalPadding)
                    Spacer().frame(height: Design.space24)
                }

                ProfileSectionHeader(title: "SETTINGS")
                    .padding(.horizontal, Design.contentHorizontalPadding)
                    .padding(.bottom, Design.space8)
                settingsCard

                Spacer().frame(height: Design.space24)
                ProfileSectionHeader(title: "PRIVACY & DATA")
                    .padding(.horizontal, Design.contentHorizontalPadding)
                    .padding(.bottom, Design.space8)
                privacyCard

                Spacer().frame(height: Design.space24)
                InfoCard(
                    title: "Your Data is Private",
                    bodyText: "All your skincare data is stored locally on your device. We don't collect, share, or sell any of your personal information."
                )
                .padding(.horizontal, Design.contentHorizontalPadding)
            }
            .padding(.top, Design.space16)
            .padding(.bottom, Design.tabBarEstimatedHeight + Design.space24)
        }
        .background(Color(hex: "F9FAFB"))
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showSurvey) {
            NavigationStack {
                PersonalizedSurveyContainerView(source: .fromProfile)
            }
        }
        .sheet(isPresented: $showPreferencesPlaceholder) { placeholderSheet(title: "Preferences") }
        .sheet(isPresented: $showPrivacyPolicyPlaceholder) { placeholderSheet(title: "Privacy Policy") }
        .overlay {
            if showDeleteProfileConfirmation {
                ConfirmRemoveModal(
                    title: "Delete Profile?",
                    message: "This will remove your profile and personalized settings from this device.",
                    destructiveButtonTitle: "Delete",
                    onCancel: { showDeleteProfileConfirmation = false },
                    onRemove: {
                        userProfileStore.resetProfile()
                        showDeleteProfileConfirmation = false
                        appState.showToast(type: .success, message: "Cleared data successfully")
                    }
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .animation(.easeOut(duration: 0.22), value: showDeleteProfileConfirmation)
        .alert("Clear All Data", isPresented: $showClearDataConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) {
                routineStore.clearAll()
                wishlistStore.clearAll()
                appState.setCompatibilityCheckCompleted(false)
                showClearDataConfirmation = false
                appState.showToast(type: .success, message: "Clear all data successfully")
            }
        } message: {
            Text("All routine products and wishlist will be removed.")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Design.space4) {
            Text("Profile")
                .font(.system(size: Design.headerTitleFontSize, weight: .bold))
                .foregroundColor(Color(hex: "111827"))
            Text("Manage your preferences and settings")
                .font(.system(size: Design.headerSubtitleFontSize))
                .foregroundColor(Color(hex: "6B7280"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Design.contentHorizontalPadding)
    }

    private var settingsCard: some View {
        VStack(spacing: 0) {
            ProfileRow(
                title: userProfileStore.isSurveyCompleted ? "Edit Profile" : "Complete Profile Setup",
                iconName: "person.fill",
                iconBackgroundColor: Color(hex: "93C5FD"),
                action: { showSurvey = true }
            )
            divider
            ProfileRow(
                title: "Preferences",
                iconName: "gearshape.fill",
                iconBackgroundColor: Color(hex: "C4B5FD"),
                action: { showPreferencesPlaceholder = true }
            )
            divider
            ProfileRow(
                title: "Delete Profile",
                iconName: "trash.fill",
                iconBackgroundColor: Color(hex: "FCA5A5"),
                isDestructive: true,
                showChevron: false,
                action: { showDeleteProfileConfirmation = true }
            )
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        .padding(.horizontal, Design.contentHorizontalPadding)
    }

    private var privacyCard: some View {
        VStack(spacing: 0) {
            ProfileRow(
                title: "Privacy Policy",
                iconName: "shield.fill",
                iconBackgroundColor: Color(hex: "86EFAC"),
                action: { showPrivacyPolicyPlaceholder = true }
            )
            divider
            ProfileRow(
                title: "Clear All Data",
                iconName: "trash.fill",
                iconBackgroundColor: Color(hex: "FCA5A5"),
                isDestructive: true,
                showChevron: false,
                action: { showClearDataConfirmation = true }
            )
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        .padding(.horizontal, Design.contentHorizontalPadding)
    }

    private var divider: some View {
        Rectangle()
            .fill(dividerColor)
            .frame(height: 1)
    }

    private func placeholderSheet(title: String) -> some View {
        NavigationStack {
            Text("\(title) – Coming soon")
                .font(.headline)
                .foregroundColor(Color(hex: "6B7280"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") { dismissSheets() }
                    }
                }
        }
        .presentationDetents([.medium])
    }

    private func dismissSheets() {
        showPreferencesPlaceholder = false
        showPrivacyPolicyPlaceholder = false
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserProfileStore())
        .environmentObject(RoutineStore())
        .environmentObject(WishlistStore())
        .environmentObject(AppState())
}
