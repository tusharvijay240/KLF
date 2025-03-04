//
//  Toast.swift
//  AttendenceScanner
//
//  Created by Tushar on 03/02/25.
//

import Foundation
import Toastify

class Toast {
    
    static func show(
        message: String,
        duration: TimeInterval = 1.0,
        backgroundColor: UIColor = .link,
        textColor: UIColor = .white,
        position: ToastConfig.Position = .top,
        animation: Bool = true
    ) {
        ToastifyManager.shared.showMessage(
            message,
            duration: duration,
            backgroundColor: backgroundColor,
            textColor: textColor,
            position: position,
            animation: animation
        )
    }
}
