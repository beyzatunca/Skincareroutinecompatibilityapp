import SwiftUI

/// AM / PM / Both pill row. Single-select; selected = mint fill + darker text.
struct SegmentedPillSelector: View {
    @Binding var selection: RoutineTimeOfDay

    private static let mintBackground = Color(hex: "B8E6D5")
    private static let mintText = Color(hex: "047857")
    private static let borderGray = Color(hex: "E5E7EB")
    private static let textGray = Color(hex: "374151")
    private static let pillCornerRadius: CGFloat = 20

    var body: some View {
        HStack(spacing: Design.space12) {
            ForEach(RoutineTimeOfDay.allCases, id: \.self) { option in
                pillButton(option)
            }
        }
    }

    private func pillButton(_ option: RoutineTimeOfDay) -> some View {
        let isSelected = selection == option
        return Button {
            selection = option
        } label: {
            Text(option.rawValue)
                .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                .foregroundColor(isSelected ? Self.mintText : Self.textGray)
                .padding(.horizontal, Design.space20)
                .padding(.vertical, Design.space12)
                .background(
                    RoundedRectangle(cornerRadius: Self.pillCornerRadius)
                        .fill(isSelected ? Self.mintBackground : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Self.pillCornerRadius)
                        .stroke(Self.borderGray, lineWidth: isSelected ? 0 : 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    struct Holder: View {
        @State var selection: RoutineTimeOfDay = .pm
        var body: some View {
            SegmentedPillSelector(selection: $selection)
                .padding()
        }
    }
    return Holder()
}
