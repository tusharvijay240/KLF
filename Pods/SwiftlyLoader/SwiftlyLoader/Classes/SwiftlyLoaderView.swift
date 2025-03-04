//
//  SwiftlyLoaderView.swift
//  SwiftlyLoader
//
//  Created by Tushar on 03/02/25.
//

import Foundation
import UIKit
import Lottie

public class SwiftlyLoaderView: UIView {
    private let containerView = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    private var lottieView: LottieAnimationView?
    private var config: SwiftlyLoaderConfig!
    
    init(config: SwiftlyLoaderConfig) {
        super.init(frame: UIScreen.main.bounds)
        self.config = config
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.clear
        containerView.backgroundColor = config.backgroundColor
        containerView.layer.cornerRadius = config.cornerRadius
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        
        switch config.loaderType {
        case .systemIndicator(let style):
            setupSystemIndicator(style: style)
        case .lottie(let animation):
            setupLottieAnimation(named: animation.rawValue)
        }
        
        setupConstraints()
    }
    
    private func setupSystemIndicator(style: UIActivityIndicatorView.Style) {
        activityIndicator.style = style
        activityIndicator.color = config.indicatorColor
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func setupLottieAnimation(named animationName: String) {
        let frameworkBundle = Bundle(for: SwiftlyLoaderView.self)
        if let path = frameworkBundle.path(forResource: "Resources", ofType: "bundle"),
           let resourceBundle = Bundle(url: URL(fileURLWithPath: path)),
           let animation = LottieAnimation.named(animationName, bundle: resourceBundle) {  // ✅ FIXED: Load animation correctly
            
            let animationView = LottieAnimationView(animation: animation)  // ✅ FIXED: Initialize correctly
            animationView.loopMode = .loop  // ✅ FIXED: Set loop mode correctly
            animationView.animationSpeed = config.animationSpeed
            animationView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(animationView)
            animationView.play()
            self.lottieView = animationView
            
            applyColorToLottie(animationView: animationView)
        } else {
            print("❌ ERROR: Lottie animation '\(animationName)' not found in Resources.bundle")
        }
    }
    
    /// Apply the loader color to Lottie animations dynamically
    private func applyColorToLottie(animationView: LottieAnimationView) {
        let keypaths = [
            "**.Fill 1.Color",
            "**.Stroke 1.Color",
            "**.Fill.Color",
            "**.Stroke.Color",
            "**.Layer 1.Fill 1.Color"
        ]

        let colorProvider = ColorValueProvider(config.indicatorColor.lottieColorValue)
        for keypath in keypaths {
            animationView.setValueProvider(colorProvider, keypath: AnimationKeypath(keypath: keypath))
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: config.containerSize),
            containerView.heightAnchor.constraint(equalToConstant: config.containerSize)
        ])
        
        if let lottieView = lottieView {
            NSLayoutConstraint.activate([
                lottieView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                lottieView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                lottieView.widthAnchor.constraint(equalToConstant: config.indicatorSize),
                lottieView.heightAnchor.constraint(equalToConstant: config.indicatorSize)
            ])
        } else {
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
        }
    }
}
