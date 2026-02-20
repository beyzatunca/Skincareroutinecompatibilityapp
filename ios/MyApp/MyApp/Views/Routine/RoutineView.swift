import SwiftUI

/// "Manage My Products" screen: list of routine items with editable Time of Day and Frequency.
struct RoutineView: View {
    @EnvironmentObject private var routineStore: RoutineStore
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var showRemoveModal = false
    @State private var pendingDeleteItemId: String?

    var body: some View {
        ZStack {
            mainContent
            if showRemoveModal {
                modalOverlay
            }
        }
        .animation(.easeOut(duration: 0.22), value: showRemoveModal)
    }

    private var mainContent: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: Design.space20) {
                headerSection
                itemsList
            }
            .padding(.horizontal, Design.contentHorizontalPadding)
            .padding(.top, Design.space16)
            .padding(.bottom, Design.tabBarEstimatedHeight + Design.space24)
        }
        .background(Color(hex: "F9FAFB"))
    }

    private var modalOverlay: some View {
        ConfirmRemoveModal(
            title: "Remove Product?",
            message: "Are you sure you want to remove this product from your routine?",
            onCancel: {
                withAnimation(.easeOut(duration: 0.22)) {
                    showRemoveModal = false
                    pendingDeleteItemId = nil
                }
            },
            onRemove: {
                if let id = pendingDeleteItemId {
                    routineStore.delete(itemId: id)
                }
                withAnimation(.easeOut(duration: 0.22)) {
                    showRemoveModal = false
                    pendingDeleteItemId = nil
                }
                appState.selectedTab = .home
                dismiss()
            }
        )
        .transition(.scale(scale: 0.92).combined(with: .opacity))
        .zIndex(1000)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Manage My Products")
                .font(.system(size: Design.headerTitleFontSize, weight: .bold))
                .foregroundColor(Color(hex: "111827"))
            Text("\(routineStore.items.count) products in your routine")
                .font(.system(size: Design.surveySubtextFontSize))
                .foregroundColor(Color(hex: "6B7280"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, Design.space8)
    }

    private var itemsList: some View {
        VStack(spacing: Design.space16) {
            ForEach(routineStore.items) { item in
                RoutineItemCardView(
                    item: item,
                    onUpdate: { id, timeOfDay, frequency in
                        routineStore.update(itemId: id, timeOfDay: timeOfDay, frequency: frequency)
                    },
                    onDelete: { id in
                        pendingDeleteItemId = id
                        withAnimation(.easeOut(duration: 0.22)) {
                            showRemoveModal = true
                        }
                    }
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        RoutineView()
            .environmentObject(RoutineStore())
            .environmentObject(AppState())
    }
}
