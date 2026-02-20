import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "leaf.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green.gradient)
            Text("Skincare Routine")
                .font(.title.bold())
            Text("Compatibility App")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
