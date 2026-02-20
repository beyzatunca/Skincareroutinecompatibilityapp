import SwiftUI

struct OnboardingPageView: View {
    let slide: OnboardingSlide
    
    private let designContainerW: CGFloat = 384
    private let designContainerH: CGFloat = 256
    /// Ekrana sığması için ölçek (375 - 64 padding = 311; 311/384)
    private var scatteredScale: CGFloat { min(1, (UIScreen.main.bounds.width - 64) / designContainerW) }
    private var scaledWidth: CGFloat { designContainerW * scatteredScale }
    private var scaledHeight: CGFloat { designContainerH * scatteredScale }

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
        Group {
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
        .frame(maxWidth: .infinity)
    }

    private func scatteredImages(topLeft: String, centerRight: String, bottomCenter: String) -> some View {
        let cardW: CGFloat = 160
        let cardH: CGFloat = 208
        let corner: CGFloat = 16
        let containerW = designContainerW
        let containerH = designContainerH
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
        .scaleEffect(scatteredScale)
        .frame(width: scaledWidth, height: scaledHeight)
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
