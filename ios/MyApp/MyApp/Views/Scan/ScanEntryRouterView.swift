import SwiftUI
import AVFoundation

/// Decides which screen to show based on camera permission; no nested NavigationStack.
struct ScanEntryRouterView: View {
    @Binding var path: NavigationPath
    @State private var permissionGranted: Bool?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Group {
            if let granted = permissionGranted {
                if granted {
                    BarcodeScannerView()
                } else {
                    CameraAccessDeniedView(
                        onDismiss: { popOne() },
                        onSearchInstead: { popToProducts() }
                    )
                }
            } else {
                Color.black
                    .ignoresSafeArea()
                    .overlay {
                        ProgressView()
                            .tint(.white)
                    }
            }
        }
        .task {
            await evaluatePermission()
        }
    }

    private func evaluatePermission() async {
        let status = CameraPermissionService.currentStatus()
        switch status {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            let granted = await CameraPermissionService.requestAccess()
            permissionGranted = granted
        case .denied, .restricted:
            permissionGranted = false
        @unknown default:
            permissionGranted = false
        }
    }

    private func popOne() {
        if path.count > 0 {
            path.removeLast()
        } else {
            dismiss()
        }
    }

    /// Dismiss scan flow and return to Products screen.
    private func popToProducts() {
        if path.count > 0 {
            path.removeLast()
        } else {
            dismiss()
        }
    }
}

#Preview {
    ScanEntryRouterView(path: .constant(NavigationPath()))
}
