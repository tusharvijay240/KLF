//
//  CodeScanner.swift
//  CodeScanner
//
//  Created by 須藤 将史 on 2017/02/15.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit
import AVFoundation

public class CodeScanner: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var captureDevice: AVCaptureDevice?
    private var types: [AVMetadataObject.ObjectType]
    private var preview: UIView
    private var scanAreaView: UIView?
    private var resultOutputs: (([String]) -> Void)?
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    private var highlightView: UIView?

    public init(metadataObjectTypes: [AVMetadataObject.ObjectType], preview: UIView, scanAreaView: UIView? = nil) {
        self.types = metadataObjectTypes
        self.preview = preview
        self.scanAreaView = scanAreaView
        super.init()
        self.configureCaptureSession()
    }
    
    public func viewDidLayoutSubviews() {
        updatePreviewLayerFrame()
    }

    private func configureCaptureSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let inputDevice = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(inputDevice) {
                captureSession.addInput(inputDevice)
            }

            let metaOutput = AVCaptureMetadataOutput()
            if captureSession.canAddOutput(metaOutput) {
                captureSession.addOutput(metaOutput)
                metaOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metaOutput.metadataObjectTypes = self.types
                setupScanArea(for: metaOutput)
            }

            self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.previewLayer?.videoGravity = .resizeAspectFill
            updatePreviewLayerFrame()
            self.preview.layer.insertSublayer(self.previewLayer!, at: 0)
        } catch {
            print("Error configuring capture session: \(error)")
        }
    }

    private func updatePreviewLayerFrame() {
        self.previewLayer?.frame = preview.bounds
    }

    private func setupScanArea(for output: AVCaptureMetadataOutput) {
        guard let scanAreaView = scanAreaView else { return }
        
        let borderView = UIView(frame: scanAreaView.bounds)
        scanAreaView.addSubview(borderView)
        
        let pFrame = preview.bounds
        let sFrame = scanAreaView.frame
        
        output.rectOfInterest = CGRect(
            x: sFrame.minY / pFrame.height,
            y: sFrame.minX / pFrame.width,
            width: sFrame.height / pFrame.height,
            height: sFrame.width / pFrame.width
        )

    }

    public func start() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    public func stop() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }

    public func scan(resultOutputs: @escaping ([String]) -> Void) {
        self.resultOutputs = resultOutputs
        start()
    }

    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var detectionStrings: [String] = []
        for metadataObject in metadataObjects {
            guard let readableCodeObject = previewLayer?.transformedMetadataObject(for: metadataObject) as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableCodeObject.stringValue,
                  types.contains(readableCodeObject.type) else {
                continue
            }
            detectionStrings.append(stringValue)
            DispatchQueue.main.async { [weak self] in
                self?.highlightDetectedCode(readableCodeObject)
                self?.feedbackGenerator.notificationOccurred(.success)
            }
        }
        if !detectionStrings.isEmpty {
            DispatchQueue.main.async {
                self.resultOutputs?(detectionStrings)
            }
        }
    }

    private func highlightDetectedCode(_ codeObject: AVMetadataMachineReadableCodeObject) {
        let highlightFrame = codeObject.bounds
        self.highlightView?.removeFromSuperview()
        let highlightView = UIView(frame: adjustHighlightFrame(highlightFrame))
        highlightView.layer.borderColor = UIColor.systemBlue.cgColor
        highlightView.layer.borderWidth = 3
        self.preview.addSubview(highlightView)
        self.highlightView = highlightView
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.highlightView?.removeFromSuperview()
        }
        stop()
    }

    func adjustHighlightFrame(_ originalFrame: CGRect) -> CGRect {
        var adjustedFrame = originalFrame
        let aspectRatio = originalFrame.width / originalFrame.height
        let minimumSize: CGFloat = 20

        if aspectRatio > 5 { // Horizontal barcode
            if originalFrame.height < 20 {
                adjustedFrame.origin.y -= (20 - originalFrame.height) / 2
                adjustedFrame.size.height = 50
            }
        } else if aspectRatio < 0.2 { // Vertical barcode
            if originalFrame.width < 20 {
                adjustedFrame.origin.x -= (20 - originalFrame.width) / 2
                adjustedFrame.size.width = 50
            }
        } else {
            if originalFrame.width < minimumSize {
                adjustedFrame.size.width = minimumSize
            }
            if originalFrame.height < minimumSize {
                adjustedFrame.size.height = 50
            }
        }
        return adjustedFrame
    }
}
