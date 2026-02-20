import SwiftUI

struct SurveyStepTwoView: View {
    @ObservedObject var viewModel: PersonalizedSurveyViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Design.surveySectionSpacing) {
                SurveyHelperBullets(items: [
                    "Select all skin concerns",
                    "Mark if you have sensitivity",
                    "We'll find matching products"
                ])
                SurveySectionHeader(title: "Select all that apply")

                chipGridMulti(
                    items: SurveyConcern.allCases.map(\.rawValue),
                    selected: Set(viewModel.selectedConcerns.map(\.rawValue))
                ) { raw in
                    SurveyConcern(rawValue: raw).map { viewModel.toggleConcern($0) }
                }

                SurveyCheckboxRow(
                    title: "I have sensitive skin prone to irritation",
                    subtitle: nil,
                    isOn: viewModel.hasSensitiveSkin,
                    action: { viewModel.hasSensitiveSkin = !viewModel.hasSensitiveSkin }
                )
            }
            .padding(.horizontal, Design.surveyHorizontalMargin)
            .padding(.top, Design.space16)
            .padding(.bottom, Design.space24)
        }
    }

    private func chipGridMulti(
        items: [String],
        selected: Set<String>,
        onToggle: @escaping (String) -> Void
    ) -> some View {
        LazyVGrid(columns: adaptiveColumns(), spacing: Design.surveyChipSpacing) {
            ForEach(items, id: \.self) { item in
                SelectableChip(
                    title: item,
                    isSelected: selected.contains(item),
                    action: { onToggle(item) }
                )
            }
        }
    }

    private func adaptiveColumns() -> [GridItem] {
        [GridItem(.adaptive(minimum: Design.surveyChipMinColumnWidth), spacing: Design.surveyChipSpacing)]
    }
}

#Preview {
    SurveyStepTwoView(viewModel: PersonalizedSurveyViewModel())
        .padding()
}
