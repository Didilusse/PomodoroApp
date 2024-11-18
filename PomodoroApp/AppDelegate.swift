//
//  AppDelegate.swift
//  PomodoroApp
//
//  Created by Adil Rahmani on 11/17/24.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var popover: NSPopover!
    let timerManager = TimerManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the menu bar item
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.title = "Timer"

        // Configure the popover
        popover = NSPopover()
        popover.contentViewController = NSHostingController(rootView: TimerView(timerManager: timerManager))

        // Add button action to show/hide the popover
        if let button = statusBarItem.button {
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
    }

    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            if let button = statusBarItem.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
