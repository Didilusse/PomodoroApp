//
//  TimerManagement.swift
//  PomodoroApp
//
//  Created by Adil Rahmani on 11/17/24.
//

import Foundation
import UserNotifications

class TimerManager: ObservableObject {
    @Published var counter: Int = 0 // Time elapsed
    @Published var totalTime: Int = 1500 // Default 25-minute timer (work mode)
    private var timer: Timer?
    @Published var isRunning: Bool = false

    enum TimerMode {
        case work
        case rest
        case idle
    }

    @Published var currentMode: TimerMode = .work {
        didSet {
            onModeChange?(currentMode)
        }
    }

    var onUpdate: ((Int) -> Void)?
    var onModeChange: ((TimerMode) -> Void)?

    init() {
        requestNotificationPermission()
    }

    func startTimer() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.incrementTime()
        }
    }

    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
    }

    func resetTimer() {
        isRunning = false
        timer?.invalidate()
        counter = 0
        totalTime = 1500
        currentMode = .work
        onUpdate?(remainingTime)
    }

    private func incrementTime() {
        if counter < totalTime {
            counter += 1
            onUpdate?(remainingTime)
        } else {
            sendNotification()
            switchMode()
        }
    }

    private func switchMode() {
        pauseTimer()
        counter = 0
        if currentMode == .work {
            currentMode = .rest
            totalTime = 300
        } else {
            currentMode = .work
            totalTime = 1500
        }
        startTimer()
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            } else if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }

    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = currentMode == .work ? "Time to Take a Break!" : "Back to Work!"
        content.body = currentMode == .work
            ? "You’ve completed a 25-minute work session. Take a 5-minute break."
            : "Your 5-minute break is over. Let’s get back to work!"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // Immediate notification
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send notification: \(error)")
            }
        }
    }

    var remainingTime: Int {
        return totalTime - counter
    }

    var progress: Double {
        return Double(counter) / Double(totalTime)
    }

    var modeDescription: String {
        switch currentMode {
        case .work: return "Work"
        case .rest: return "Rest"
        case .idle: return "Idle"
        }
    }
}
