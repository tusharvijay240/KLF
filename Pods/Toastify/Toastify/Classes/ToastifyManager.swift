//
//  ToastifyManager.swift
//  Toastify
//
//  Created by Tushar on 31/01/25.
//

import UIKit

public class ToastifyManager {
    
    public static let shared = ToastifyManager()
    
    private var floatingContainer: UIView?
    
    private init() {}

    public func showToast(config: ToastConfig) {
        DispatchQueue.main.async { [weak self] in
            guard let window = UIApplication.shared.windows.first else {
                Logger.debug("❌ No window found for displaying toast")
                return
            }
            
            // Create floating container if not exists
            if self?.floatingContainer == nil {
                let container = UIView(frame: window.bounds)
                container.backgroundColor = .clear
                container.isUserInteractionEnabled = false // ✅ Allows touch events to pass through
                window.addSubview(container)
                self?.floatingContainer = container
            }

            let toast = ToastView(config: config)
            Logger.debug("🚀 Showing toast with message: \(config.message)")
            self?.floatingContainer?.addSubview(toast)
            toast.show(in: self?.floatingContainer ?? window, duration: config.duration, position: config.position)
        }
    }
    
    public func showMessage(
        _ message: String,
        duration: TimeInterval = 2.0,
        backgroundColor: UIColor = .black,
        textColor: UIColor = .white,
        position: ToastConfig.Position = .bottom,
        animation: Bool = true
    ) {
        let config = ToastConfig(
            message: message,
            duration: duration,
            backgroundColor: backgroundColor,
            textColor: textColor,
            position: position,
            animation: animation
        )
        
        showToast(config: config)
    }
}
