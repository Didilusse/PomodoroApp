//
//  AppDelegate.swift
//  PomodoroApp
//
//  Created by Adil Rahmani on 11/17/24.
//
import Cocoa
import SwiftUI
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var popover: NSPopover!
    let timerManager = TimerManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Request notification permissions
        requestNotificationPermission()
        // Create the menu bar item
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.title = "Pomodoro: 25:00" // Default title

        // Configure the popover
        popover = NSPopover()
        popover.contentViewController = NSHostingController(rootView: TimerView(timerManager: timerManager))

        // Add button action to show/hide the popover
        if let button = statusBarItem.button {
            button.action = #selector(togglePopover(_:))
            button.target = self
        }

        // Observe timer updates
        timerManager.onUpdate = { [weak self] remainingTime in
            DispatchQueue.main.async {
                self?.statusBarItem.button?.title = "\(self?.timerManager.modeDescription ?? "Pomodoro"): \(self?.formatTime(remainingTime) ?? "00:00")"
            }
        }

        // Observe mode changes and handle notifications
        timerManager.onModeChange = { [weak self] newMode in
            DispatchQueue.main.async {
                self?.sendNotification(for: newMode)
            }
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

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func sendNotification(for mode: TimerManager.TimerMode) {
        let content = UNMutableNotificationContent()
        switch mode {
        case .work:
            content.title = "Time to Work!"
            content.body = "Focus for the next 25 minutes."
        case .rest:
            content.title = "Take a Break!"
            content.body = "Relax for 5 minutes."
        case .idle:
            return // No notification for idle state
        }
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func requestNotificationPermission() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        print("Notification permission granted")
                    } else {
                        print("Notification permission denied")
                    }
                }
            }
        }
}
