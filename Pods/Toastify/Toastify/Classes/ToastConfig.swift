//
//  ToastConfig.swift
//  Toastify
//
//  Created by Tushar on 31/01/25.
//

import Foundation
import UIKit

public struct ToastConfig {
    public enum Position {
        case top, middle, bottom
    }
    
    public var message: String
    public var duration: TimeInterval
    public var backgroundColor: UIColor
    public var textColor: UIColor
    public var position: Position
    public var animation: Bool
    
    public init(
        message: String,
        duration: TimeInterval = 2.0,
        backgroundColor: UIColor = .black,
        textColor: UIColor = .white,
        position: Position = .bottom,
        animation: Bool = true
    ) {
        self.message = message
        self.duration = duration
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.position = position
        self.animation = animation
    }
}
