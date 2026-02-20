import SwiftUI
import AVFoundation

struct BarcodeScannerView: View {
    @StateObject private var sessionHolder = BarcodeScannerSessionHolder()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            if sessionHolder.isSessionRunning {
                CameraPreview(session: sessionHolder.session)
                    .ignoresSafeArea()
            } else {
                Color.black
                    .ignoresSafeArea()
            }
            scanOverlay
        }
        .navigationBarHidden(true)
        .overlay(alignment: .topLeading) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
            .padding(.leading, Design.space8)
            .padding(.top, Design.space8)
        }
        .onAppear {
            sessionHolder.startSession()
        }
        .onDisappear {
            sessionHolder.stopSession()
        }
    }

    private var scanOverlay: some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.8), lineWidth: 2)
                .frame(width: 260, height: 160)
            Text("Scan a barcode")
                .font(.system(size: Design.surveySubtextFontSize))
                .foregroundColor(.white.opacity(0.9))
                .padding(.top, Design.space16)
            Spacer()
        }
    }
}

/// Holds AVCaptureSession and starts/stops it. Graceful when camera unavailable (e.g. simulator).
final class BarcodeScannerSessionHolder: NSObject, ObservableObject {
    let session = AVCaptureSession()
    @Published var isSessionRunning = false

    func startSession() {
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            return
        }
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            return
        }
        session.addInput(input)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
            DispatchQueue.main.async {
                self?.isSessionRunning = true
            }
        }
    }

    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
        isSessionRunning = false
    }
}

#Preview {
    BarcodeScannerView()
}
