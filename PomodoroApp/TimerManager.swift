//
//  TimerManagement.swift
//  PomodoroApp
//
//  Created by Adil Rahmani on 11/17/24.
//

import Foundation

class TimerManager {
    private var timer: Timer?
        private(set) var counter: Int = 0
        var isRunning: Bool = false

        var onTimeUpdate: ((String) -> Void)?

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
            updateTime()
        }

        private func incrementTime() {
            counter += 1
            updateTime()
        }

        private func updateTime() {
            let minutes = counter / 60
            let seconds = counter % 60
            let formattedTime = String(format: "%02d:%02d", minutes, seconds)
            onTimeUpdate?(formattedTime)
        }
}
