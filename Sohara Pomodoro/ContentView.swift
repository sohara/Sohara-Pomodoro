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

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
            }
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
            Button("Pause") {
                timer?.invalidate()
            }
            Button("Reset") {
                timer?.invalidate()
                timeRemaining = 1500
            }
        }
        .padding()
    }
}




#Preview {
    ContentView()
}
