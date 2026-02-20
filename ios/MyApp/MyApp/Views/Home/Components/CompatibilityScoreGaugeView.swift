import SwiftUI

/// Semi-circular compatibility score gauge: 0–100 with colored arc, score number and label. Animates from 0 to target score.
struct CompatibilityScoreGaugeView: View {
    let score: Int
    @State private var displayedScore: Double = 0

    private func label(for value: Int) -> String {
        switch value {
        case 80...100: return "Excellent"
        case 60..<80: return "Good"
        case 40..<60: return "Fair"
        default: return "Poor"
        }
    }

    private func labelColor(for value: Int) -> Color {
        switch value {
        case 80...100: return Color(hex: "059669")
        case 60..<80: return Color(hex: "7C3AED")
        case 40..<60: return Color(hex: "D97706")
        default: return Color(hex: "B91C1C")
        }
    }

    var body: some View {
        VStack(spacing: 4) {
            ZStack(alignment: .bottom) {
                // Background arc (full semi-circle)
                GaugeArcShape(progress: 1.0)
                    .stroke(Color(hex: "E5E7EB"), lineWidth: 12)
                    .frame(width: 160, height: 88)

                // Filled arc: animates from 0 to score/100
                GaugeArcShape(progress: CGFloat(displayedScore) / 100.0)
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "22C55E"), Color(hex: "A855D8")],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 160, height: 88)

                // Score text at center-bottom of arc (animates 0 → score)
                VStack(spacing: 0) {
                    Text("\(Int(displayedScore.rounded()))")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color(hex: "111827"))
                        .contentTransition(.numericText())
                    Text(label(for: Int(displayedScore.rounded())))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(labelColor(for: Int(displayedScore.rounded())))
                }
                .offset(y: 22)
            }
            .frame(height: 100)
            .onAppear {
                withAnimation(.easeOut(duration: 1.4)) {
                    displayedScore = Double(score)
                }
            }
            .onChange(of: score) { _, newValue in
                displayedScore = 0
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 1.4)) {
                        displayedScore = Double(newValue)
                    }
                }
            }

            // 0 and 100 labels at ends of arc
            HStack {
                Text("0")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "9CA3AF"))
                Spacer()
                Text("100")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "9CA3AF"))
            }
            .frame(width: 160)
            .padding(.horizontal, 4)
        }
        .padding(.vertical, Design.space8)
    }
}

/// Arc from bottom-left to bottom-right (semi-circle), progress 0...1.
private struct GaugeArcShape: Shape {
    var progress: CGFloat

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        let radius = min(rect.width, rect.height * 2) / 2
        let startDegrees = 180.0
        let endDegrees = startDegrees + 180.0 * Double(progress)
        var path = Path()
        path.addArc(center: center, radius: radius, startAngle: .degrees(startDegrees), endAngle: .degrees(endDegrees), clockwise: false)
        return path
    }
}

#Preview {
    CompatibilityScoreGaugeView(score: 74)
        .padding()
}
