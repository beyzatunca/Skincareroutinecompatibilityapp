import SwiftUI

enum AppTab: Int, CaseIterable {
    case home = 0
    case discover
    case profile

    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .discover: return "square.stack.3d.up.fill"
        case .profile: return "person.fill"
        }
    }

    var title: String {
        switch self {
        case .home: return "Home"
        case .discover: return "Discover"
        case .profile: return "Profile"
        }
    }
}

struct BottomTabBar: View {
    @Binding var selectedTab: AppTab

    private let activeTeal = Color(hex: "0D9488")
    private let inactiveGray = Color(hex: "9CA3AF")

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.rawValue) { tab in
                tabItem(tab)
            }
        }
        .padding(.top, Design.tabBarTopPadding)
        .padding(.bottom, Design.tabBarBottomPadding)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color(hex: "E5E7EB"))
                .frame(height: 1),
            alignment: .top
        )
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: -2)
    }

    private func tabItem(_ tab: AppTab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: Design.space4) {
                Image(systemName: tab.iconName)
                    .font(.system(size: Design.tabBarIconSize))
                    .foregroundColor(selectedTab == tab ? activeTeal : inactiveGray)
                Text(tab.title)
                    .font(.system(size: Design.tabBarLabelFontSize, weight: .medium))
                    .foregroundColor(selectedTab == tab ? activeTeal : inactiveGray)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        Spacer()
        BottomTabBar(selectedTab: .constant(.home))
    }
}
