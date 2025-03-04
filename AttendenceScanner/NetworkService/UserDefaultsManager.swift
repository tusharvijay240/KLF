//
//  UserDefaultsManager.swift
//  AttendenceScanner
//
//  Created by Tushar on 10/02/25.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let tokenKey = "userLoginToken"
    private let userIdKey = "userId" 

    private init() {}

    // Save Token and User ID (Convert Int to String)
    func saveUserSession(token: String, userId: Int) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        UserDefaults.standard.set("\(userId)", forKey: userIdKey) // Convert Int to String
        UserDefaults.standard.synchronize()
    }

    // Retrieve Token
    func getUserToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }

    // Retrieve User ID (Return as Int)
    func getUserId() -> Int? {
        return UserDefaults.standard.string(forKey: userIdKey).flatMap { Int($0) } // Convert back to Int
    }

    // Check if User is Logged In
    func isUserLoggedIn() -> Bool {
        return getUserToken() != nil
    }

    // Logout Function
    func logoutUser() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.synchronize()
    }
}
