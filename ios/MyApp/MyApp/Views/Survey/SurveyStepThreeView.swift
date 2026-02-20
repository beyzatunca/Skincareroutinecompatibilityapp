import SwiftUI

struct SurveyStepThreeView: View {
    @ObservedObject var viewModel: PersonalizedSurveyViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Design.surveySectionSpacing) {
                SurveyHelperBullets(items: [
                    "Choose ingredients to avoid",
                    "Flag pregnancy if applicable",
                    "These settings are optional"
                ])
                SurveySectionHeader(title: "Ingredients to avoid (optional)")

                chipGridMulti(
                    items: SurveyAvoidance.allCases.map(\.rawValue),
                    selected: Set(viewModel.avoidedIngredients.map(\.rawValue))
                ) { raw in
                    SurveyAvoidance(rawValue: raw).map { viewModel.toggleAvoidance($0) }
                }

                SurveyCheckboxRow(
                    title: "I'm pregnant or planning to be",
                    subtitle: "We'll flag products not recommended during pregnancy",
                    isOn: viewModel.isPregnant,
                    action: { viewModel.isPregnant = !viewModel.isPregnant }
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
    SurveyStepThreeView(viewModel: PersonalizedSurveyViewModel())
        .padding()
}
