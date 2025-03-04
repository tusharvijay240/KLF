//
//  SwiftlyLoader.swift
//  SwiftlyLoader
//
//  Created by Tushar on 03/02/25.
//

import Foundation
import UIKit

public class SwiftlyLoader {
    public static let shared = SwiftlyLoader() // Singleton instance

    private var loaderView: SwiftlyLoaderView?

    private init() {}

    public func show(config: SwiftlyLoaderConfig = SwiftlyLoaderConfig()) {
        hide() // Ensure any previous loader is removed

        guard let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow }) })
            .first else {
            print("❌ Error: No key window found")
            return
        }

        let loader = SwiftlyLoaderView(config: config)
        self.loaderView = loader
        keyWindow.addSubview(loader)
    }

    public func hide() {
        loaderView?.removeFromSuperview()
        loaderView = nil
    }
}
