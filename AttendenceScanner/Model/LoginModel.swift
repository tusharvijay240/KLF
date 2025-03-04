//
//  UserResponseModel.swift
//  AttendenceScanner
//
//  Created by Tushar on 13/02/25.
//


import Foundation

struct LoginModel: Codable {
    let status: String?
    let message: String?
    let data: LoginData?

    enum CodingKeys: String, CodingKey {
        case status, message, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        message = try container.decodeIfPresent(String.self, forKey: .message)

        if let loginData = try? container.decode(LoginData.self, forKey: .data) {
            data = loginData
        } else {
            data = nil
        }
    }
}


struct LoginData: Codable {
    let userID: Int?
    let userLogin: String?
    let userNicename: String?
    let userEmail: String?
    let displayName: String?
    let userToken: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userLogin = "user_login"
        case userNicename = "user_nicename"
        case userEmail = "user_email"
        case displayName = "display_name"
        case userToken = "user_token"
    }
}

class LoginService {
    
    func userLogin(username: String? = nil, password: String? = nil, completion: @escaping (Result<LoginModel, Error>) -> Void) {
        
        let parameters: [String: Any] = [
            "wp_username": username ?? "",
            "wp_password": password ?? "",
        ]
        
        NetworkService.shared.post(url: APIConstants.login, parameters: parameters, completion: completion)
    }
}
