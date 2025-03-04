//
//  Indicator.swift
//  AttendenceScanner
//
//  Created by Apple on 30/12/24.
//

import UIKit
import SwiftlyLoader

class Indicator {
    
    static func show(
        backgroundColor: UIColor = .black.withAlphaComponent(0.4),
        indicatorColor: UIColor = .link,
        indicatorSize: CGFloat = 180,
        cornerRadius: CGFloat = 10.0,
        animationSpeed: CGFloat = 1.0,
        lottieAnimation: LoaderAnimation = .circularSpinner
    ) {
        
        let config = SwiftlyLoaderConfig(
            backgroundColor: backgroundColor,
            indicatorColor: indicatorColor,
            indicatorSize: indicatorSize,
            cornerRadius: cornerRadius,
            loaderType: .lottie(animation: .circularSpinner),
            animationSpeed: animationSpeed
        )

        SwiftlyLoader.shared.show(config: config)
    }
    
    static func hide() {
        SwiftlyLoader.shared.hide()
    }
}

