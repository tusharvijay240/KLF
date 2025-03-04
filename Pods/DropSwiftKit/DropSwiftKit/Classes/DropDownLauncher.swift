//
//  DropDownLauncher.swift
//  DropSwiftKit
//
//  Created by Tushar on 30/01/25.
//

import Foundation
import UIKit

public class DropdownLauncher {
    
    /// Shows a dropdown menu or action sheet
    public static func show(
        from sourceView: UIView,
        actions: [DropdownAction],
        style: DropdownStyle
    ) {
        switch style {
        case .menu:
            DropdownMenuPresenter.show(from: sourceView, actions: actions)
        case .sheet:
            DropdownSheetPresenter.show(from: sourceView, actions: actions)
        }
    }
}
