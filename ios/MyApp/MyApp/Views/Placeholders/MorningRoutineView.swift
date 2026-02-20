import SwiftUI

struct MorningRoutineView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: Design.space16) {
            Text("Morning Routine")
                .font(.title.bold())
            Text("Placeholder screen")
                .foregroundColor(.secondary)
            Button("Dismiss") { dismiss() }
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
    }
}
