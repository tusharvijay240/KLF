//
//  EventLoginViewController.swift
//  AttendenceScanner
//
//  Created by Tushar on 10/02/25.
//

import Foundation
import UIKit

class EventLoginViewController: UIViewController {
    
    @IBOutlet weak var txtUserId: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    private var isPasswordVisible: Bool = false
    let loginService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    @IBAction func didTapLogin(_ sender: UIButton) {
        if !validateFields() {
            return
        }
        
        if ReachabilityService.shared.isReachable {
            loginAPI()
        } else {
            Toast.show(message: "No Network Connection")
        }
       
    }
    
    func loginAPI() {
        Indicator.show()

        loginService.userLogin(username: txtUserId.text, password: txtPassword.text) { result in
            DispatchQueue.main.async {
                Indicator.hide()

                switch result {
                case .success(let loginResponse):
                    Logger.log("🔵 API Success: \(loginResponse)")

                    if loginResponse.status == "success", let userData = loginResponse.data {
                        // ✅ Successful login
                        UserDefaultsManager.shared.saveUserSession(token: userData.userToken ?? "", userId: userData.userID ?? 0)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let eventVC = storyboard.instantiateViewController(withIdentifier: "EventsViewController") as! EventsViewController
                        self.navigationController?.pushViewController(eventVC, animated: true)
                    } else {
                        // ❌ Login failed, display API message
                        Logger.log("❌ Login Failed: \(loginResponse.message ?? "Unknown error")")
                        Toast.show(message: loginResponse.message ?? "Login failed.")
                    }

                case .failure(let error):
                    Logger.log("❌ API Failure: \(error.localizedDescription)")
                    Toast.show(message: "Login request failed: \(error.localizedDescription)")
                }
            }
        }
    }

}

extension EventLoginViewController: UITextFieldDelegate {
    
    func configUI() {
        let btnEye = UIButton(type: .custom)
        btnEye.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btnEye.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -10.0, bottom: 0.0, right: 10.0)
        if let eyeImage = UIImage(named: "hiddenEye")?.withRenderingMode(.alwaysTemplate) {
            btnEye.setImage(eyeImage, for: .normal)
        }
        btnEye.tintColor = .link

        btnEye.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        txtPassword.rightView = btnEye
        txtPassword.rightViewMode = .always

        txtUserId.delegate = self
        txtPassword.delegate = self

        // Set the keyboard type to asciiCapable
        txtUserId.keyboardType = .asciiCapable
        txtPassword.keyboardType = .asciiCapable

        // Set Corner Radius and Border Color for Text Fields
        txtUserId.layer.cornerRadius = 8
        txtUserId.layer.borderWidth = 1
        txtUserId.layer.borderColor = UIColor.gray.cgColor

        txtPassword.layer.cornerRadius = 8
        txtPassword.layer.borderWidth = 1
        txtPassword.layer.borderColor = UIColor.gray.cgColor
        
        // Add Padding to Text Fields
        txtUserId.addPadding()
        txtPassword.addPadding()

        // Set Corner Radius for Button
        btnLogin.layer.cornerRadius = 8
        btnLogin.clipsToBounds = true
    }

    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        isPasswordVisible = !isPasswordVisible
        txtPassword.isSecureTextEntry = !isPasswordVisible
        let imageName = isPasswordVisible ? "showEye" : "hiddenEye"
        sender.setImage(UIImage(named: imageName)?.withTintColor(.link), for: .normal)
    }
    
    func validateFields() -> Bool {
        if txtUserId.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            Toast.show(message: "Please enter valid user id")
            return false
        } else if txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            Toast.show(message: "Please enter valid password")
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Check if the text field is the email text field
        if textField == txtUserId {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 100
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
          if textField == txtUserId || textField == txtPassword {
              textField.keyboardType = .asciiCapable
          }
          return true
      }
}

