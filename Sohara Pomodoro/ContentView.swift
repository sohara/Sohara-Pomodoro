//
//  ContentView.swift
//  Sohara Pomodoro
//
//  Created by Sean O'Hara on 2023-11-12.
//

import SwiftUI

struct ContentView: View {
    @State private var timeRemaining = 1500 // 25 minutes in seconds
    @State private var timer: Timer?
    @State private var isTimerRunning = false
    @State private var timerStarted = false

    func startTimer() {
        // Only create a timer if it's not already running
        if !isTimerRunning {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    stopTimer()
                }
            }
            isTimerRunning = true
            timerStarted = true
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    func pauseResumeTimer() {
        if isTimerRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    func timeString(from totalSeconds: Int) -> String {
          let minutes = totalSeconds / 60
          let seconds = totalSeconds % 60
          return String(format: "%02d:%02d", minutes, seconds)
      }
    
    var body: some View {
        VStack {
            Text(timeString(from: timeRemaining))
                .font(.largeTitle)
                .monospacedDigit()
            Button("Start") {
                startTimer()
            }
            Button(timerStarted && isTimerRunning ? "Pause" : "Resume") {
                pauseResumeTimer()
            }
            .disabled(!timerStarted)
            .opacity(timerStarted ? 1 : 0.3)
            Button("Reset") {
                stopTimer()
                timeRemaining = 1500
                timerStarted = false
            }
        }
        .padding()
    }
}




#Preview {
    ContentView()
}
