//
//  VcQR.swift
//  AttendenceScanner
//
//  Created by Tushar on 15/01/25.
//


import UIKit
import CodeScanner
import AVFoundation

class QRViewController: UIViewController {
    
    @IBOutlet weak var vwPreview: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var vwScanningArea: UIView!
    
    var codeScanner: CodeScanner?
    var onScanResult: ((String) -> Void)?
    
    private var isProcessingResult = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        codeScanner?.viewDidLayoutSubviews()
    }
    
    func configUI() {
        setupScanner()
    }
    
    private func setupScanner() {
        setupBorderView()
        let metadataObjectTypes: [AVMetadataObject.ObjectType] = [
            .qr, .code128, .code39, .code39Mod43, .code93,
            .ean8, .ean13, .pdf417, .upce, .aztec, .dataMatrix,
            .interleaved2of5, .itf14
        ]
        
        codeScanner = CodeScanner(
            metadataObjectTypes: metadataObjectTypes,
            preview: vwPreview,
            scanAreaView: vwScanningArea
        )
        
        codeScanner?.scan(resultOutputs: { [weak self] results in
            guard let self = self, let result = results.first, !results.isEmpty else { return }
        
            if self.isProcessingResult { return }
            self.isProcessingResult = true
            
            self.codeScanner?.stop()
            self.dismiss(animated: true) {
                self.onScanResult?(result)
                self.isProcessingResult = false
            }
        })
        
        addCloseButton()
    }
    
    func addCloseButton() {
        btnClose.setImage(UIImage(named: "cross"), for: .normal)
        btnClose.tintColor = .link
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    @objc func didTapClose() {
        codeScanner?.stop()
        isProcessingResult = false
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        codeScanner?.stop()
    }
    
    private func setupBorderView() {
        let borderView = BorderView(frame: vwScanningArea.bounds)
        vwScanningArea.addSubview(borderView)
    }
}
