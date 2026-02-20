import CoreGraphics

enum Design {
    /// 8pt spacing grid (consistent horizontal padding for all major elements)
    static let space4: CGFloat = 4
    static let space8: CGFloat = 8
    static let space12: CGFloat = 12
    static let space16: CGFloat = 16
    static let space20: CGFloat = 20
    static let space24: CGFloat = 24
    static let space32: CGFloat = 32
    static let space40: CGFloat = 40
    static let space48: CGFloat = 48
    static let space56: CGFloat = 56
    static let space64: CGFloat = 64

    /// Horizontal padding for screen content (align all major elements)
    static let contentHorizontalPadding: CGFloat = 24

    static let actionButtonSize: CGFloat = 64
    static let routineCardPlusButtonSize: CGFloat = 40
    static let learnCardHeight: CGFloat = 192
    static let learnCardCornerRadius: CGFloat = 24
    static let routineCardCornerRadius: CGFloat = 16
    static let overlayChevronButtonSize: CGFloat = 32

    static let headerTitleFontSize: CGFloat = 24
    static let headerSubtitleFontSize: CGFloat = 14
    static let sectionTitleFontSize: CGFloat = 18
    static let routineCardTitleFontSize: CGFloat = 18
    static let routineCardSubtitleFontSize: CGFloat = 12
    static let learnCardTitleFontSize: CGFloat = 20
    static let learnCardDescriptionFontSize: CGFloat = 14
    static let actionLabelFontSize: CGFloat = 14

    /// Tab bar
    static let tabBarIconSize: CGFloat = 24
    static let tabBarLabelFontSize: CGFloat = 10
    static let tabBarTopPadding: CGFloat = 8
    static let tabBarBottomPadding: CGFloat = 24
    /// Estimated height of tab bar (content + padding) for scroll bottom inset
    static let tabBarEstimatedHeight: CGFloat = 84

    /// Routine card
    static let routineCardMinHeight: CGFloat = 148
    static let routineCardPlusButtonSizeFixed: CGFloat = 44

    /// Survey (8pt grid, responsive)
    static let surveyHorizontalMargin: CGFloat = 24
    static let surveyChipHeight: CGFloat = 44
    static let surveyChipMinColumnWidth: CGFloat = 120
    static let surveyProgressBarHeight: CGFloat = 6
    static let surveySectionSpacing: CGFloat = 24
    static let surveyChipSpacing: CGFloat = 12
    static let surveyTitleFontSize: CGFloat = 22
    static let surveySectionTitleFontSize: CGFloat = 17
    static let surveyBodyFontSize: CGFloat = 15
    static let surveySubtextFontSize: CGFloat = 13
    static let surveyCTACornerRadius: CGFloat = 28
    static let surveyCTAVerticalPadding: CGFloat = 16
    static let surveyStickyCTABottomPadding: CGFloat = 24
    /// Height reserved at bottom for sticky CTA strip (divider + button + padding). Used for overlay + content padding.
    static let surveyStickyCTAStripHeight: CGFloat = 100

    /// Products screen
    static let productsSearchBarHeight: CGFloat = 44
    static let productsChipHeight: CGFloat = 36
    static let productsCardCornerRadius: CGFloat = 16
    static let productsThumbnailSize: CGFloat = 64
    static let productsRowPadding: CGFloat = 12

    /// Product Detail screen
    static let productDetailHeroCornerRadius: CGFloat = 20
    static let productDetailHeroAspectRatio: CGFloat = 1.0
    static let productDetailPillCornerRadius: CGFloat = 12
    static let productDetailMatchCardCornerRadius: CGFloat = 16
    static let productDetailFloatingButtonSize: CGFloat = 56
    static let productDetailChatButtonSize: CGFloat = 56
    static let productDetailFloatingBarBottomPadding: CGFloat = 34
    /// ScrollView bottom padding so content is not hidden behind floating bar + safe area + 24
    static let productDetailScrollBottomPadding: CGFloat = 200
    static let productDetailPanelCornerRadius: CGFloat = 16
    static let productDetailPanelShadowRadius: CGFloat = 8
}
