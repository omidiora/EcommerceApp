//
//  EcommerceAppApp.swift
//  EcommerceApp
//
//  Created by Omidiora Emmanuel on 13/02/2026.
//

import SwiftUI
import FirebaseCore

@main
struct EcommerceAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
        init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
