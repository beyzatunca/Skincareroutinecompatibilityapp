import SwiftUI

struct ChatFloatingButton: View {
    var action: () -> Void = {}
    var showNotificationDot: Bool = true

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "message.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color(hex: "7C3AED"))
                    .frame(width: Design.productDetailChatButtonSize, height: Design.productDetailChatButtonSize)
                    .background(Circle().fill(Color.white))
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)

                if showNotificationDot {
                    Circle()
                        .fill(Color(hex: "EC4899"))
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .offset(x: 2, y: -2)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack(alignment: .bottomTrailing) {
        Color.clear
        ChatFloatingButton()
            .padding(.trailing, Design.space24)
            .padding(.bottom, 120)
    }
}
