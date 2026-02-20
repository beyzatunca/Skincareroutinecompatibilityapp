import Foundation

struct LearnCard: Identifiable {
    let id: String
    let title: String
    let description: String
    let tag: String
    let imageName: String?

    static let dummyCards: [LearnCard] = [
        LearnCard(
            id: "1",
            title: "Morning Skincare Routine",
            description: "Essential steps for glowing skin",
            tag: "Routine",
            imageName: "learn_1"
        ),
        LearnCard(
            id: "2",
            title: "Retinol + Vitamin C Guide",
            description: "Can you use them together?",
            tag: "Education",
            imageName: "learn_2"
        ),
        LearnCard(
            id: "3",
            title: "Protect Your Skin Barrier",
            description: "Signs & solutions for damaged skin",
            tag: "Health",
            imageName: "learn_3"
        )
    ]
}
