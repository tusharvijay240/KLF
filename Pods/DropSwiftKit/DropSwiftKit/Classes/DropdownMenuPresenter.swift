//
//  DropDownLauncher.swift
//  DropSwiftKit
//
//  Created by Tushar on 30/01/25.
//

import UIKit

public class DropdownMenuPresenter {
    
    /// Shows a dropdown menu using UIMenu
    public static func show(from sourceView: UIView, actions: [DropdownAction]) {
        let menuActions = actions.map { action in
            UIAction(title: action.title, image: action.icon) { _ in
                action.handler()
            }
        }
        
        let menu = UIMenu(title: "", children: menuActions)
        
        if let button = sourceView as? UIButton {
            button.menu = menu
            button.showsMenuAsPrimaryAction = true
        } else {
            print("❌ DropSwiftKit: Source view is not a UIButton. Menu can only be attached to buttons.")
        }
    }
}
