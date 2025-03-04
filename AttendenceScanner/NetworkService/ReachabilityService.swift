//
//  NetworkManager.swift
//  GloRep-SDK
//
//  Created by Apple on 27/11/24.
//
import Alamofire

class ReachabilityService {
    static let shared = ReachabilityService()
    private let reachabilityManager = NetworkReachabilityManager()
    private init() {
        reachabilityManager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                Logger.log("The network is not reachable")
            case .unknown :
                Logger.log("It is unknown whether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                Logger.log("The network is reachable over the WiFi connection")
            case .reachable(.cellular):
                Logger.log("The network is reachable over the cellular connection")
            }
        })
    }
    
    var isReachable: Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    var isReachableOnCellular: Bool {
        return reachabilityManager?.isReachableOnCellular ?? false
    }
    
    var isReachableOnWiFi: Bool {
        return reachabilityManager?.isReachableOnEthernetOrWiFi ?? false
    }
}


