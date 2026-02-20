import SwiftUI

/// AI Coach floating button: gradient circle, smiley face, notification dot, bounce and tap animations.
struct AIChatbotButton: View {
    var productId: String?
    var onTap: () -> Void
    var showNotificationDot: Bool = true

    @State private var bounceOffset: CGFloat = 0
    @State private var isPressed = false

    private let size: CGFloat = 56
    private let bounceHeight: CGFloat = 8
    private let bounceDuration: Double = 2

    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isPressed = false
                }
                onTap()
            }
        }) {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "E8D5F2"), Color(hex: "F0E3F7")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size, height: size)
                    .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)

                Circle()
                    .fill(Color.white)
                    .frame(width: size - 12, height: size - 12)

                smileyFace
                    .frame(width: size - 12, height: size - 12)

                if showNotificationDot {
                    Circle()
                        .fill(Color(hex: "EC4899"))
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                        .offset(x: 2, y: -2)
                }
            }
            .scaleEffect(isPressed ? 0.94 : 1)
            .offset(y: bounceOffset)
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(
                .easeInOut(duration: bounceDuration / 2)
                .repeatForever(autoreverses: true)
            ) {
                bounceOffset = -bounceHeight
            }
        }
        .zIndex(200)
    }

    private var smileyFace: some View {
        ZStack {
            Circle()
                .stroke(Color.clear, lineWidth: 0)
                .frame(width: 24, height: 24)
                .overlay(
                    Group {
                        Circle()
                            .fill(Color(hex: "581C87"))
                            .frame(width: 4, height: 4)
                            .offset(x: -5, y: -2)
                        Circle()
                            .fill(Color(hex: "581C87"))
                            .frame(width: 4, height: 4)
                            .offset(x: 5, y: -2)
                    }
                )
            SmileyMouth()
                .frame(width: 22, height: 14)
                .scaleEffect(x: 1, y: -1)
                .offset(y: 5)
        }
    }
}

/// Gülümseme: eğri yukarı bakmalı. SwiftUI Path Y aşağı artar; kontrol noktası baseline'ın ÜSTÜNDE (küçük y) = kavis yukarı.
private struct SmileyMouth: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let baselineY = h * 0.70
            let controlY = h * 0.25
            Path { p in
                p.move(to: CGPoint(x: w * 0.18, y: baselineY))
                p.addQuadCurve(
                    to: CGPoint(x: w * 0.82, y: baselineY),
                    control: CGPoint(x: w * 0.50, y: controlY)
                )
            }
            .stroke(
                Color(red: 0x58/255, green: 0x1C/255, blue: 0x87/255),
                style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
            )
        }
    }
}

#Preview {
    ZStack(alignment: .bottomTrailing) {
        Color.gray.opacity(0.2)
        AIChatbotButton(productId: nil, onTap: {})
            .padding(.trailing, 24)
            .padding(.bottom, 96)
    }
}
