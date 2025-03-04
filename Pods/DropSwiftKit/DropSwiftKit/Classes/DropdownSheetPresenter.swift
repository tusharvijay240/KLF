//
//  DropdownSheetPresenter.swift
//  DropSwiftKit
//
//  Created by Tushar on 30/01/25.
//

import Foundation
import UIKit

public class DropdownSheetPresenter {
    
    /// Shows an action sheet dropdown
    public static func show(from sourceView: UIView, actions: [DropdownAction]) {
        guard let parentViewController = sourceView.window?.rootViewController else {
            print("❌ DropSwiftKit: Cannot find parent view controller.")
            return
        }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: .default) { _ in
                action.handler()
            }
            actionSheet.addAction(alertAction)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popover = actionSheet.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
        }
        
        parentViewController.present(actionSheet, animated: true)
    }
}
