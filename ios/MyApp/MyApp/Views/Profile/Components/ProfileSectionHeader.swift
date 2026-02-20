import SwiftUI

struct ProfileSectionHeader: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(Color(hex: "9CA3AF"))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 8) {
        ProfileSectionHeader(title: "SETTINGS")
        ProfileSectionHeader(title: "PRIVACY & DATA")
    }
    .padding()
}
