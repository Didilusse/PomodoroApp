//
//  MenuBuilder.swift
//  PomodoroApp
//
//  Created by Adil Rahmani on 11/17/24.
//

import Cocoa

class MenuBuilder {
    private let timerManager: TimerManager
    private weak var statusBarItem: NSStatusItem?

    init(timerManager: TimerManager, statusBarItem: NSStatusItem?) {
        self.timerManager = timerManager
        self.statusBarItem = statusBarItem
    }

    func buildMenu() -> NSMenu {
            let menu = NSMenu()

            let startItem = NSMenuItem(title: "Start", action: #selector(startTimer), keyEquivalent: "S")
            startItem.target = self
            menu.addItem(startItem)

            let pauseItem = NSMenuItem(title: "Pause", action: #selector(pauseTimer), keyEquivalent: "P")
            pauseItem.target = self
            menu.addItem(pauseItem)

            let resetItem = NSMenuItem(title: "Cancel", action: #selector(resetTimer), keyEquivalent: "C")
            resetItem.target = self
            menu.addItem(resetItem)

            menu.addItem(NSMenuItem.separator())

            let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "Q")
            quitItem.target = self
            menu.addItem(quitItem)

            return menu
        }

    @objc private func startTimer() {
        timerManager.startTimer()
    }

    @objc private func pauseTimer() {
        timerManager.pauseTimer()
    }

    @objc private func resetTimer() {
        timerManager.resetTimer()
    }

    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
