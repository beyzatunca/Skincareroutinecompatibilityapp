import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0

    private let slides = OnboardingSlide.slides
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                ForEach(Array(slides.enumerated()), id: \.offset) { index, slide in
                    OnboardingPageView(slide: slide)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            
            onboardingFooter
        }
        .navigationBarHidden(true)
    }
    
    private var onboardingFooter: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [Color.white.opacity(0), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 24)
            
            VStack(spacing: 0) {
                pageIndicators
                    .padding(.bottom, 24)
                
                getStartedButton
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            .padding(.bottom, 48)
            .background(Color.white)
        }
    }
    
    private var pageIndicators: some View {
        HStack(spacing: 8) {
            ForEach(0..<slides.count, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? AnyShapeStyle(onboardingGradient) : AnyShapeStyle(Color(hex: "D1D5DB")))
                    .frame(width: index == currentPage ? 32 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
    }
    
    private var getStartedButton: some View {
        Button {
            hasSeenOnboarding = true
        } label: {
            Text("Get Started")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "111827"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [
                            Color(hex: "C8E6E0"),
                            Color(hex: "D8F0EC"),
                            Color(hex: "F0F9F7")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
    
    private var onboardingGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: "C8E6E0"),
                Color(hex: "D8F0EC"),
                Color(hex: "F0F9F7")
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

#Preview {
    NavigationStack {
        OnboardingView()
    }
}
