//
//  SwiftlyLoaderConfig.swift
//  SwiftlyLoader
//
//  Created by Tushar on 03/02/25.
//

import Foundation
import UIKit

public enum LoaderType {
    case systemIndicator(style: UIActivityIndicatorView.Style)
    case lottie(animation: LoaderAnimation)
}

public enum LoaderAnimation: String {
    case circularSpinner = "circularSpinner"
    case waveDots = "waveDots"
    case infinityLine = "infinityLine"
    case barLine = "barLine"
}

public struct SwiftlyLoaderConfig {
    public var backgroundColor: UIColor
    public var indicatorColor: UIColor
    public var indicatorSize: CGFloat
    public var cornerRadius: CGFloat
    public var loaderType: LoaderType
    public var animationSpeed: CGFloat
    public var containerSize: CGFloat

    public init(
        backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.6),
        indicatorColor: UIColor = UIColor.white,
        indicatorSize: CGFloat = 60.0,
        cornerRadius: CGFloat = 10.0,
        loaderType: LoaderType = .systemIndicator(style: .large),
        animationSpeed: CGFloat = 1.0,
        containerSize: CGFloat = 100.0
    ) {
        self.backgroundColor = backgroundColor
        self.indicatorColor = indicatorColor
        self.indicatorSize = indicatorSize
        self.cornerRadius = cornerRadius
        self.loaderType = loaderType
        self.animationSpeed = animationSpeed
        self.containerSize = containerSize
    }
}
