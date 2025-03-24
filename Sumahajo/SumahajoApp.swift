//
//  SumahajoApp.swift
//  Sumahajo
//
//  Created by Su Thiri Kyaw on 3/10/25.
//

import SwiftUI

@main
struct SumahajoApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate  // Use AppKit for window management
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Small delay to ensure window is initialized
                window.toggleFullScreen(nil)
            }
        }
    }
}
