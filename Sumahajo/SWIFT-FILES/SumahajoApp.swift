//
//  SumahajoApp.swift
//  Sumahajo
//
//  Created by Su Thiri Kyaw on 3/10/25.
//

import SwiftUI

@main
struct SumahajoApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ViewController()
            SpriteTest()

        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                window.toggleFullScreen(nil)
            }
        }
    }
}
