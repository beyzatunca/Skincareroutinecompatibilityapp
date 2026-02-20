import SwiftUI

struct LearnDiscoverCarousel: View {
    let cards: [LearnCard]
    var onCardTap: (LearnCard) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: Design.space16) {
            Text("Learn & Discover")
                .font(.system(size: Design.sectionTitleFontSize, weight: .semibold))
                .foregroundColor(Color(hex: "111827"))
                .padding(.horizontal, Design.contentHorizontalPadding)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Design.space16) {
                    ForEach(cards) { card in
                        LearnCardCell(card: card) {
                            onCardTap(card)
                        }
                    }
                }
                .padding(.horizontal, Design.contentHorizontalPadding)
                .padding(.vertical, Design.space8)
            }
        }
    }
}

struct LearnCardCell: View {
    let card: LearnCard
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                cardBackground
                gradientOverlay
                contentOverlay
                chevronOverlayButton
            }
            .frame(width: cardWidth, height: Design.learnCardHeight)
            .clipShape(RoundedRectangle(cornerRadius: Design.learnCardCornerRadius))
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    private var cardWidth: CGFloat {
        UIScreen.main.bounds.width - Design.contentHorizontalPadding * 2 - Design.space16
    }

    private var cardBackground: some View {
        LinearGradient(
            colors: [
                Color(hex: "C8E6E0"),
                Color(hex: "D8F0EC")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var gradientOverlay: some View {
        LinearGradient(
            colors: [
                Color.black.opacity(0.7),
                Color.black.opacity(0.2),
                Color.clear
            ],
            startPoint: .bottom,
            endPoint: .top
        )
    }

    private var contentOverlay: some View {
        VStack(alignment: .leading, spacing: Design.space4) {
            Text(card.tag)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, Design.space12)
                .padding(.vertical, Design.space4)
                .background(Color(hex: "06b6d4").opacity(0.9))
                .clipShape(Capsule())
            Text(card.title)
                .font(.system(size: Design.learnCardTitleFontSize, weight: .semibold))
                .foregroundColor(.white)
            Text(card.description)
                .font(.system(size: Design.learnCardDescriptionFontSize))
                .foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Design.space20)
    }

    private var chevronOverlayButton: some View {
        VStack {
            HStack {
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: Design.overlayChevronButtonSize, height: Design.overlayChevronButtonSize)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(Design.space16)
            }
            Spacer()
        }
    }
}

#Preview {
    LearnDiscoverCarousel(cards: LearnCard.dummyCards)
}
