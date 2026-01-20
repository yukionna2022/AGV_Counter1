//
//  AGVMLModel.swift
//  AGVML_000
//
//  Created by Yu Ke on 19.01.26.
//

import AVFoundation
import Vision
import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    @Binding var scannedString: String

    // Serial queue for all AVCaptureSession operations
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    // Separate queue for Vision barcode processing
    private let videoQueue = DispatchQueue(label: "videoQueue")

    let captureSession = AVCaptureSession()

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()

        sessionQueue.async { [captureSession] in
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
                  let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
                  captureSession.canAddInput(videoInput) else { return }

            captureSession.addInput(videoInput)

            let videoOutput = AVCaptureVideoDataOutput()
            if captureSession.canAddOutput(videoOutput) {
                Task { @MainActor in

                    videoOutput.setSampleBufferDelegate(context.coordinator, queue: self.videoQueue)
                }

                captureSession.addOutput(videoOutput)
            }

            captureSession.startRunning()
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        
        
        
    }

    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: ScannerView

        init(_ parent: ScannerView) {
            self.parent = parent
        }

        nonisolated func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {


            
            



        }
    }
}
