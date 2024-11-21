//
//  PomodoroAppApp.swift
//  PomodoroApp
//
//  Created by Adil Rahmani on 11/17/24.
//

import SwiftUI

@main
struct PomodoroAppApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
            Settings {
                ContentView() // Placeholder view
            }
        }
}
