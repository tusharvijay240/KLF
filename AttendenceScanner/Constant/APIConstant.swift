//
//  APIConstant.swift
//  GloRep-SDK
//
//  Created by Apple on 27/11/24.
//

import Alamofire

enum Environment {
    case dev
    case prod
}

struct APIConstants {
    static let currentEnvironment: Environment = .prod

    static var baseURL: String {
        switch currentEnvironment {
        case .dev:
            return "https://klf.oaxpire.com/wp-json/psyeventsmanager/v1/"
        case .prod:
            return "https://klf.oaxpire.com/wp-json/psyeventsmanager/v1/"
        }
    }
    
    static let loginEndpoint = "login"
    static let eventListEndpoint = "event/list"
    static let eventDetailEndpoint = "event/detail/"
    static let logoutEndpoint = "logout"
    
    static var login: String {
        return baseURL + loginEndpoint
    }
    
    static var eventList: String {
        return baseURL + eventListEndpoint
    }
    
    static func eventDetail(eventID: String, userToken: String) -> String {
            return "\(baseURL)\(eventDetailEndpoint)/?id=\(eventID)&user_token=\(userToken)"
        }
    
    static var logout: String {
        return baseURL + logoutEndpoint
    }
    
    
}
