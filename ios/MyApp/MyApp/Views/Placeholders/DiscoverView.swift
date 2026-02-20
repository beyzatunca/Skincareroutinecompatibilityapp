import SwiftUI

struct DiscoverView: View {
    var body: some View {
        VStack(spacing: Design.space16) {
            Text("Discover")
                .font(.title.bold())
            Text("Placeholder tab")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
