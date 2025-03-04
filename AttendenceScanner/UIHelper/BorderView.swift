//
//  BorderView.swift
//  AttendenceScanner
//
//  Created by Tushar on 15/01/25.
//


import UIKit

class BorderView: UIView {
    private var borderLayers: [CALayer] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        setupBorders()
    }
    
    private func setupBorders() {
        borderLayers.forEach { $0.removeFromSuperlayer() }
        borderLayers.removeAll()
        
        let thickness: CGFloat = 3
        let length: CGFloat = 48
        
        // Top left corner
        borderLayers.append(addBorder(frame: CGRect(x: 0, y: 0, width: thickness, height: length)))
        borderLayers.append(addBorder(frame: CGRect(x: 0, y: 0, width: length, height: thickness)))

        // Top right corner
        borderLayers.append(addBorder(frame: CGRect(x: bounds.width - thickness, y: 0, width: thickness, height: length)))
        borderLayers.append(addBorder(frame: CGRect(x: bounds.width - length, y: 0, width: length, height: thickness)))

        // Bottom left corner
        borderLayers.append(addBorder(frame: CGRect(x: 0, y: bounds.height - length, width: thickness, height: length)))
        borderLayers.append(addBorder(frame: CGRect(x: 0, y: bounds.height - thickness, width: length, height: thickness)))

        // Bottom right corner
        borderLayers.append(addBorder(frame: CGRect(x: bounds.width - thickness, y: bounds.height - length, width: thickness, height: length)))
        borderLayers.append(addBorder(frame: CGRect(x: bounds.width - length, y: bounds.height - thickness, width: length, height: thickness)))
    }
    
    private func addBorder(frame: CGRect) -> CALayer {
        let border = CALayer()
        border.frame = frame
        border.backgroundColor = UIColor.link.cgColor
        layer.addSublayer(border)
        return border
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorders()
    }
}
