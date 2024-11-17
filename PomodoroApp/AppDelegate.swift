//
//  AppDelegate.swift
//  PomodoroApp
//
//  Created by Adil Rahmani on 11/17/24.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var menuBuilder: MenuBuilder! // Keep a reference
    let timerManager = TimerManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize MenuBuilder and build the menu
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.title = "00:00"
        menuBuilder = MenuBuilder(timerManager: timerManager, statusBarItem: statusBarItem)
        statusBarItem.menu = menuBuilder.buildMenu()

        // Connect timer updates to the status bar
        timerManager.onTimeUpdate = { [weak self] formattedTime in
            self?.statusBarItem.button?.title = formattedTime
        }
    }
}
