import SwiftUI

struct AddProductsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showSurvey = false

    var body: some View {
        VStack(spacing: Design.space16) {
            Text("Add Products")
                .font(.title.bold())
            Text("Placeholder screen")
                .foregroundColor(.secondary)
            NavigationLink(destination: PersonalizedSurveyContainerView()) {
                Text("Get personalized recommendations")
                    .font(.body.weight(.medium))
            }
            .padding(.top, 8)
            Button("Dismiss") { dismiss() }
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
    }
}
