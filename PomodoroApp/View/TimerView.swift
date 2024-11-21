//
//  TimerView.swift
//  PomodoroApp
//
//  Created by Adil Rahmani on 11/18/24.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var timerManager: TimerManager

    var body: some View {
        VStack {
            Text(timerManager.modeDescription)
                .font(.title)
                .bold()
                .padding()

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 10) // Background circle
                    .frame(width: 150, height: 150)

                Circle()
                    .trim(from: 0.0, to: CGFloat(timerManager.progress))
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [Color.blue, Color.green]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90)) // Start at the top
                    .frame(width: 150, height: 150)

                Text("\(timerManager.remainingTime / 60):\(String(format: "%02d", timerManager.remainingTime % 60))")
                    .font(.largeTitle)
                    .bold()
            }
            .padding()

            HStack {
                Button(action: { timerManager.startTimer() }) {
                    Text("Start")
                }
                .buttonStyle(.borderedProminent)

                Button(action: { timerManager.pauseTimer() }) {
                    Text("Pause")
                }
                .buttonStyle(.bordered)

                Button(action: { timerManager.resetTimer() }) {
                    Text("Reset")
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .frame(width: 250, height: 300)
    }
}
