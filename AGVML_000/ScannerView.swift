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

        //setupAVCapture
        
        var bufferSize: CGSize = .zero
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .vga640x480 // Model image size is smaller.
        
        sessionQueue.async { [captureSession] in
            guard let videoCaptureDevice =  AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first,
                  let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
                  captureSession.canAddInput(videoInput) else {
                print("Could not add video device input to the session")
                captureSession.commitConfiguration()
                return
            }

            captureSession.addInput(videoInput)
            
            /**
             videoOutput - 全局变量在🥣
             */
            let videoOutput = AVCaptureVideoDataOutput()
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
                
                Task { @MainActor in
                    videoOutput.alwaysDiscardsLateVideoFrames = true
                    videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
                    videoOutput.setSampleBufferDelegate(context.coordinator, queue: self.videoQueue)
                }
            } else {
                print("Could not add video data output to the session")
                captureSession.commitConfiguration()
                return
            }
            
            let captureConnection = videoOutput.connection(with: .video)
            // Always process the frames
            captureConnection?.isEnabled = true
            do {
                try videoCaptureDevice.lockForConfiguration()
                let dimensions = CMVideoFormatDescriptionGetDimensions((videoCaptureDevice.activeFormat.formatDescription))
                bufferSize.width = CGFloat(dimensions.width)
                bufferSize.height = CGFloat(dimensions.height)
                videoCaptureDevice.unlockForConfiguration()
            } catch {
                print(error)
            }
            
            /**
             startCaptureSession - 在🥣最后才call
             */
            captureSession.startRunning()
        }
        
        captureSession.commitConfiguration()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
//        captureSession.startRunning()

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        

        
    }

    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    /*
     Coordinator
     */

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: ScannerView

        init(_ parent: ScannerView) {
            self.parent = parent
            
            
            
        }

        nonisolated func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            // to be implemented in the subclass
        }
        

        
        
        
        
        
    }
    
    
    
    

}
