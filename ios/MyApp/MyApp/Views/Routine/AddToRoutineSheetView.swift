import SwiftUI

/// "Add to Routine" bottom sheet: Time of Day (AM/PM/Both), Frequency rows, Add Product + Cancel.
struct AddToRoutineSheetView: View {
    let product: Product?
    let onConfirm: (RoutineSelection) -> Void
    let onCancel: () -> Void

    @State private var selection: RoutineSelection = .default

    private static let titleFontSize: CGFloat = 20
    private static let sectionTitleColor = Color(hex: "374151")

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 0) {
                titleSection
                timeOfDaySection
                frequencySection
                addProductButton
                cancelButton
            }
            .padding(.horizontal, Design.contentHorizontalPadding)
            .padding(.top, Design.space8)
            .padding(.bottom, Design.space32)
        }
        .background(Color.white)
    }

    private var titleSection: some View {
        Text("Add to Routine")
            .font(.system(size: Self.titleFontSize, weight: .bold))
            .foregroundColor(Color(hex: "111827"))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, Design.space4)
            .padding(.bottom, Design.space20)
    }

    private var timeOfDaySection: some View {
        VStack(alignment: .leading, spacing: Design.space12) {
            Text("Time of Day")
                .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                .foregroundColor(Self.sectionTitleColor)
            SegmentedPillSelector(selection: $selection.timeOfDay)
        }
        .padding(.bottom, Design.space20)
    }

    private var frequencySection: some View {
        VStack(alignment: .leading, spacing: Design.space12) {
            Text("Frequency")
                .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                .foregroundColor(Self.sectionTitleColor)
            VStack(spacing: Design.space12) {
                SelectableListRow(title: RoutineFrequency.daily.rawValue, isSelected: selection.frequency == .daily) {
                    selection.frequency = .daily
                }
                SelectableListRow(title: RoutineFrequency.twoThreePerWeek.rawValue, isSelected: selection.frequency == .twoThreePerWeek) {
                    selection.frequency = .twoThreePerWeek
                }
                SelectableListRow(title: RoutineFrequency.alternateDays.rawValue, isSelected: selection.frequency == .alternateDays) {
                    selection.frequency = .alternateDays
                }
            }
        }
        .padding(.bottom, Design.space24)
    }

    private var addProductButton: some View {
        PrimaryCTAButton(title: "Add Product") {
            onConfirm(selection)
        }
        .padding(.bottom, Design.space16)
    }

    private var cancelButton: some View {
        Button(action: onCancel) {
            Text("Cancel")
                .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                .foregroundColor(Self.sectionTitleColor)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    AddToRoutineSheetView(
        product: nil,
        onConfirm: { _ in },
        onCancel: {}
    )
}
