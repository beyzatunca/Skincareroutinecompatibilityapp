import Foundation

struct OnboardingSlide {
    let title: String
    let bullets: [String]
    let imageStyle: ImageStyle
    
    enum ImageStyle {
        case single(String)
        case scattered(topLeft: String, centerRight: String, bottomCenter: String)
    }
    
    static let slides: [OnboardingSlide] = [
        OnboardingSlide(
            title: "Not all skincare products\nwork well together",
            bullets: [
                "Some ingredients can reduce effectiveness",
                "Others may cause skin irritation",
                "We check compatibility before issues occur"
            ],
            imageStyle: .single("OnboardingCompatibility")
        ),
        OnboardingSlide(
            title: "Find products that truly match\nyour skin goals",
            bullets: [
                "Tailored to your skin type and concerns",
                "Aligned with your expectations",
                "Supporting your skincare goals"
            ],
            imageStyle: .single("OnboardingScanning")
        ),
        OnboardingSlide(
            title: "Build a healthy routine\nfor your skin type",
            bullets: [
                "Fix product compatibility issues",
                "Update your routine safely",
                "Maintain skin-friendly practices"
            ],
            imageStyle: .scattered(
                topLeft: "OnboardingRoutine3",
                centerRight: "OnboardingRoutine2",
                bottomCenter: "OnboardingRoutine1"
            )
        )
    ]
}
