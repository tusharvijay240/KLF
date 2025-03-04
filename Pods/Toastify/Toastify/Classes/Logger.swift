//
//  Logger.swift
//  Toastify
//
//  Created by Tushar on 31/01/25.
//

import Foundation

struct Logger {
    static func debug(_ message: String) {
        #if DEBUG
        print("📌 [Toastify Debug]: \(message)")
        #endif
    }
}
