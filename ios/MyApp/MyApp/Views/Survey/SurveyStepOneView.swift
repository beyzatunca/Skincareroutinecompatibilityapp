import SwiftUI

struct SurveyStepOneView: View {
    @ObservedObject var viewModel: PersonalizedSurveyViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Design.surveySectionSpacing) {
                SurveyHelperBullets(items: [
                    "Share your age range",
                    "Tell us your skin type",
                    "Help us personalize for you"
                ])
                SurveySectionHeader(title: "Age Range")
                chipGrid(items: SurveyAgeRange.allCases.map(\.rawValue), selectedItem: viewModel.selectedAgeRange?.rawValue) { raw in
                    viewModel.selectedAgeRange = SurveyAgeRange(rawValue: raw)
                }

                SurveySectionHeader(title: "Skin Type")
                chipGrid(items: SurveySkinType.allCases.map(\.rawValue), selectedItem: viewModel.selectedSkinType?.rawValue) { raw in
                    viewModel.selectedSkinType = SurveySkinType(rawValue: raw)
                }
            }
            .padding(.horizontal, Design.surveyHorizontalMargin)
            .padding(.top, Design.space16)
            .padding(.bottom, Design.space24)
        }
    }

    private func chipGrid(
        items: [String],
        selectedItem: String?,
        onSelect: @escaping (String) -> Void
    ) -> some View {
        LazyVGrid(columns: adaptiveColumns(), spacing: Design.surveyChipSpacing) {
            ForEach(items, id: \.self) { item in
                SelectableChip(
                    title: item,
                    isSelected: selectedItem == item,
                    action: { onSelect(item) }
                )
            }
        }
    }

    private func adaptiveColumns() -> [GridItem] {
        [GridItem(.adaptive(minimum: Design.surveyChipMinColumnWidth), spacing: Design.surveyChipSpacing)]
    }
}

#Preview {
    SurveyStepOneView(viewModel: PersonalizedSurveyViewModel())
        .padding()
}
