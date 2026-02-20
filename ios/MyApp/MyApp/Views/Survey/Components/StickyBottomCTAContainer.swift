import SwiftUI

struct StickyBottomCTAContainer<Content: View>: View {
    let ctaHeight: CGFloat
    let content: () -> Content

    init(ctaHeight: CGFloat = 72, @ViewBuilder content: @escaping () -> Content) {
        self.ctaHeight = ctaHeight
        self.content = content
    }

    var body: some View {
        content()
    }
}

/// Use with ScrollView: place CTA in safeAreaInset so content gets bottom padding and CTA is always visible.
struct SurveyStickyCTAModifier: ViewModifier {
    let ctaView: AnyView
    let ctaHeight: CGFloat

    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom, spacing: 0) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color(hex: "E5E7EB"))
                        .frame(height: 1)
                    ctaView
                        .padding(.horizontal, Design.surveyHorizontalMargin)
                        .padding(.top, Design.space16)
                        .padding(.bottom, Design.surveyStickyCTABottomPadding)
                }
                .background(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: -2)
            }
    }
}

extension View {
    func surveyStickyCTA(ctaHeight: CGFloat = 72, @ViewBuilder cta: () -> some View) -> some View {
        modifier(SurveyStickyCTAModifier(ctaView: AnyView(cta()), ctaHeight: ctaHeight))
    }
}
