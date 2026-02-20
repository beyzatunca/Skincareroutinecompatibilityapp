import SwiftUI

struct HowToUsePanel: View {
    private let steps: [String] = [
        "Apply 3–4 drops to clean, dry skin after cleansing and toning",
        "Gently pat into skin, avoiding the eye area",
        "Follow with moisturizer and SPF (AM) or night cream (PM)",
        "Start slowly – use 2–3 times per week and gradually increase"
    ]

    var body: some View {
        DetailPanelCard {
            VStack(alignment: .leading, spacing: Design.space12) {
                Text("How to Use")
                    .font(.system(size: Design.sectionTitleFontSize, weight: .semibold))
                    .foregroundColor(Color(hex: "111827"))

                VStack(alignment: .leading, spacing: Design.space8) {
                    ForEach(steps, id: \.self) { step in
                        HStack(alignment: .top, spacing: Design.space8) {
                            Circle()
                                .fill(Color(hex: "0D9488"))
                                .frame(width: 6, height: 6)
                                .padding(.top, 6)
                            Text(step)
                                .font(.system(size: Design.surveyBodyFontSize))
                                .foregroundColor(Color(hex: "374151"))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HowToUsePanel()
        .padding()
}
