//
//  DashboardViewController.swift
//  AttendenceScanner
//
//  Created by Tushar on 03/02/25.
//

import Foundation
import UIKit
import CameraManager
import AlamofireImage

class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnScanQR: UIButton!
    @IBOutlet weak var lblAttendenceTitle: UILabel!
    @IBOutlet weak var lblAttendence: UILabel!
    @IBOutlet weak var lblRegistrationTitle: UILabel!
    @IBOutlet weak var lblRegistration: UILabel!
    @IBOutlet weak var lblStartDateTitle: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDateTitle: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblAddressTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDisclaimerTitle: UILabel!
    @IBOutlet weak var lblDisclaimer: UILabel!
    
    let cameraManager = CameraManager()
    private var scanCount = 0
    let eventDetailService = EventDetailService()
    var eventID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appCameToForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    @objc func appCameToForeground() {
        Logger.log("📲 App returned to foreground, fetching event details...")
        fetchEventDetail(eventID: eventID)
    }

    
    func configUI() {
        checkNetworkConnectivity()
        self.fetchEventDetail(eventID: self.eventID)
    }
    
    // ✅ Fetch API Data
    func fetchEventDetail(eventID: String) {
        Indicator.show()
        
        eventDetailService.fetchEventDetail(eventID: eventID) { result in
            DispatchQueue.main.async {
                Indicator.hide()
                
                switch result {
                case .success(let eventDetailData):
                    Logger.log("🔵 API Success: \(eventDetailData)")
                    
                    if eventDetailData.status == "success" {
                        self.updateUIWithEventData(eventDetailData)
                        
                    } else {
                        if let error = eventDetailData.errorData {
                                Logger.log("❌ API Error: \(error.message ?? "Unknown error")")

                                // ✅ Handle invalid user token error
                                if let userTokenError = error.data?.params?["user_token"]?.lowercased(),
                                   userTokenError.contains("invalid parameter") {
                                    Logger.log("🚨 User token invalid, redirecting to login...")
                                    if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                                        sceneDelegate.resetToLoginScreen()
                                    }
                                } else {
                                    Toast.show(message: error.message ?? "Unknown error occurred")
                                }
                            } else {
                                Logger.log("⚠️ API returned unknown error format")
                                Toast.show(message: eventDetailData.message ?? "No event data available")
                            }
                    }
                    
                case .failure(let error):
                    Logger.log("❌ API Failure: \(error.localizedDescription)")
                    Toast.show(message: "Failed to load event details: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateUIWithEventData(_ eventData: EventDetailModel) {
        DispatchQueue.main.async {
            guard let eventData = eventData.data else {
                Logger.log("⚠️ No event data received")
                return
            }
        
            self.lblTitle.text = eventData.title ?? "No event found"
            self.lblRegistration.text = eventData.metaData?.totalSlots ?? "0"
            self.lblAttendence.text = eventData.metaData?.usedSlots ?? "0"
            self.lblStartDate.text = "\(eventData.metaData?.eventStartDate ?? "YY/MM/YYYY"), \(eventData.metaData?.eventStartTime ?? "00:00")"
            self.lblEndDate.text = "\(eventData.metaData?.eventEndDate ?? "YY/MM/YYYY"), \(eventData.metaData?.eventEndTime ?? "00:00")"
            self.lblAddress.text = eventData.metaData?.eventAddress ?? "Not found"
            self.lblDisclaimer.text = eventData.metaData?.eventDisclaimer ?? "Not found"
        }
    }
    
   
    @IBAction func didTapScanQR(_ sender: UIButton) {
        openQRScanner()
    }
    
    func openQRScanner() {
        cameraManager.askUserForCameraPermission { [weak self] granted in
            guard let self = self else { return }
            if granted {
                let qrScannerVC = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: "QRViewController") as! QRViewController
                
                qrScannerVC.onScanResult = { [weak self] scannedData in
                    guard let self = self else { return }

                    // Attach User Token
                    let modifiedData = attachUserToken(to: scannedData)

                    showAlertWithBothAction(on: self, title: "Alert", message: "Click on open link to verify the QR.", cancel: "Cancel", cancelAction: {}, confirm: "Open Link") {
                        if let url = URL(string: modifiedData) {
                            UIApplication.shared.open(url)
                        }
                    }
                }

                qrScannerVC.modalPresentationStyle = .fullScreen
                self.present(qrScannerVC, animated: true)
            } else {
                showPermissionAlert(on: self)
            }
        }
    }

    
    private func checkNetworkConnectivity() {
        if ReachabilityService.shared.isReachable {
            Logger.log("Connected to \(ReachabilityService.shared.isReachableOnWiFi ? "WiFi" : "Cellular")")
        } else {
            Toast.show(message: "No Network Connection")
        }
    }
}
