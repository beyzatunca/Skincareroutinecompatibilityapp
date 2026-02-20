import SwiftUI

struct OnboardingPageView: View {
    let slide: OnboardingSlide
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                imageSection
                    .padding(.bottom, 32)
                
                titleSection
                    .padding(.bottom, 16)
                
                descriptionSection
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 200)
            .frame(maxWidth: .infinity)
            .padding(.top, 60)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private var imageSection: some View {
        switch slide.imageStyle {
        case .single(let name):
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 256, height: 256)
        case .scattered(let topLeft, let centerRight, let bottomCenter):
            scatteredImages(topLeft: topLeft, centerRight: centerRight, bottomCenter: bottomCenter)
        }
    }
    
    private func scatteredImages(topLeft: String, centerRight: String, bottomCenter: String) -> some View {
        let cardW: CGFloat = 160
        let cardH: CGFloat = 208
        let corner: CGFloat = 16
        let containerW: CGFloat = 384
        let containerH: CGFloat = 256
        // Web: bottom center at bottom-0 left-1/2, center right top-4 right-0, top left top-0 left-0
        let bottomCenterX = (containerW - cardW) / 2
        let bottomCenterY = containerH - cardH
        let centerRightX = containerW - cardW
        let centerRightY: CGFloat = 16
        let topLeftY: CGFloat = 0
        
        return ZStack(alignment: .topLeading) {
            Image(bottomCenter)
                .resizable()
                .scaledToFill()
                .frame(width: cardW, height: cardH)
                .clipShape(RoundedRectangle(cornerRadius: corner))
                .overlay(
                    RoundedRectangle(cornerRadius: corner)
                        .stroke(Color.white, lineWidth: 4)
                )
                .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
                .rotationEffect(.degrees(3))
                .offset(x: bottomCenterX, y: bottomCenterY)
                .zIndex(1)
            
            Image(centerRight)
                .resizable()
                .scaledToFill()
                .frame(width: cardW, height: cardH)
                .clipShape(RoundedRectangle(cornerRadius: corner))
                .overlay(
                    RoundedRectangle(cornerRadius: corner)
                        .stroke(Color.white, lineWidth: 4)
                )
                .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
                .rotationEffect(.degrees(6))
                .offset(x: centerRightX, y: centerRightY)
                .zIndex(2)
            
            Image(topLeft)
                .resizable()
                .scaledToFill()
                .frame(width: cardW, height: cardH)
                .clipShape(RoundedRectangle(cornerRadius: corner))
                .overlay(
                    RoundedRectangle(cornerRadius: corner)
                        .stroke(Color.white, lineWidth: 4)
                )
                .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
                .rotationEffect(.degrees(-6))
                .offset(x: 0, y: topLeftY)
                .zIndex(3)
        }
        .frame(width: containerW, height: containerH)
    }
    
    private var titleSection: some View {
        Text(slide.title)
            .font(.system(size: 28, weight: .semibold))
            .foregroundColor(Color(hex: "111827"))
            .multilineTextAlignment(.center)
            .lineSpacing(2)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(slide.bullets.enumerated()), id: \.offset) { _, bullet in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "06b6d4"))
                    Text(bullet)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "4B5563"))
                        .lineSpacing(4)
                }
            }
        }
        .frame(maxWidth: 384, alignment: .leading)
    }
}

#Preview {
    OnboardingPageView(slide: OnboardingSlide.slides[0])
}
