//
//  DropDownActionModel.swift
//  DropSwiftKit
//
//  Created by Tushar on 30/01/25.
//

import UIKit

/// Enum to define dropdown display style
public enum DropdownStyle {
    case menu    // Shows the dropdown as a UIMenu
    case sheet   // Shows the dropdown as an action sheet
}

public struct DropdownAction {
    public let title: String       // Title of the menu action
    public let icon: UIImage?      // Optional icon
    public let handler: () -> Void // Action to perform when selected
    
    public init(title: String, icon: UIImage? = nil, handler: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.handler = handler
    }
}
