//
//  LogoutResponse.swift
//  AttendenceScanner
//
//  Created by Tushar on 17/02/25.
//


import Foundation

// MARK: - LogoutResponse Model
struct LogoutModel: Codable {
    let status: String
    let message: String
    let data: [String]?
}

class LogoutService {
    
    func userLogout(userId: String? = nil, userToken: String? = nil, completion: @escaping (Result<LogoutModel, Error>) -> Void) {
        
        let parameters: [String: Any] = [
            "user_id": userId ?? "",
            "user_token": userToken ?? "",
        ]
        
        NetworkService.shared.post(url: APIConstants.logout, parameters: parameters, completion: completion)
    }
}

