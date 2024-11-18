//
//  TimerManagement.swift
//  PomodoroApp
//
//  Created by Adil Rahmani on 11/17/24.
//

import Foundation

class TimerManager: ObservableObject {
    @Published var counter: Int = 0 // Time elapsed
    @Published var totalTime: Int = 60 // Total timer duration
    private var timer: Timer?
    @Published var isRunning: Bool = false

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
    }

    private func incrementTime() {
        if counter < totalTime {
            counter += 1
        } else {
            pauseTimer()
        }
    }

    var remainingTime: Int {
        return totalTime - counter
    }

    var progress: Double {
        return Double(counter) / Double(totalTime)
    }
}
