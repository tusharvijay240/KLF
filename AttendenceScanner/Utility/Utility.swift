//
//  Utility.swift
//  AttendenceScanner
//
//  Created by Tushar on 15/01/25.
//

import Foundation
import UIKit

enum Logger {
    static func log(_ message: String) {
        #if DEBUG
        print("[DEBUG]: \(message)")
        #endif
    }
}

func showPermissionAlert(on viewController: UIViewController) {
    let alert = UIAlertController(title: "Camera Permission Required", message: "Please enable camera access in your settings to use the QR scanner.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    viewController.present(alert, animated: true, completion: nil)
}

func showAlertWithBothAction(on viewController: UIViewController, title: String, message: String, cancel: String, cancelAction: @escaping () -> Void, confirm: String, confirmAction: @escaping () -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancelButton = UIAlertAction(title: cancel, style: .cancel) { _ in
        cancelAction()
    }
    let confirmButton = UIAlertAction(title: confirm, style: .default) { _ in
        confirmAction()
    }
    alert.addAction(cancelButton)
    alert.addAction(confirmButton)
    DispatchQueue.main.async {
        viewController.present(alert, animated: true, completion: nil)
    }
}

func showCustomDatePicker(on viewController: UIViewController, title: String, initialDate: Date?, completion: @escaping (Date) -> Void) {
    let alert = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)

    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    if let initialDate = initialDate {
        datePicker.date = initialDate
    }

    alert.view.addSubview(datePicker)
    
    NSLayoutConstraint.activate([
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50),
        datePicker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 10),
        datePicker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -10),
        datePicker.heightAnchor.constraint(equalToConstant: 150)
    ])

    let selectAction = UIAlertAction(title: "Select", style: .default) { _ in
        completion(datePicker.date)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

    alert.addAction(selectAction)
    alert.addAction(cancelAction)

    DispatchQueue.main.async {
        viewController.present(alert, animated: true, completion: nil)
    }
}

func attachUserToken(to scannedData: String) -> String {
    guard let userToken = UserDefaultsManager.shared.getUserToken(), !userToken.isEmpty else {
        return scannedData 
    }

    if var urlComponents = URLComponents(string: scannedData) {
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: "user_token", value: userToken))
        urlComponents.queryItems = queryItems
        return urlComponents.url?.absoluteString ?? scannedData
    }
    
    return scannedData
}

