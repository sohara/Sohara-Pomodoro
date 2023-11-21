//
//  ContentView.swift
//  Sohara Pomodoro
//
//  Created by Sean O'Hara on 2023-11-12.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    let pomodoroDuration = 1500 // 25 minutes in seconds
    let breakDuration = 300 // 5 minutes in seconds
    
    @State private var timeRemaining: Int
    @State private var timer: Timer?
    @State private var isTimerRunning = false
    @State private var timerStarted = false
    @State private var isBreakTime = false
    @State private var showAlert = false
    @State private var audioPlayer: AVAudioPlayer?

    init() {
        _timeRemaining = State(initialValue: pomodoroDuration)
       }
    
    func startTimer() {
        // Only create a timer if it's not already running
        if !isTimerRunning {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timeExpired()
                }
            }
            isTimerRunning = true
            timerStarted = true
        }
    }
    
    func timeExpired() {
        isBreakTime.toggle()
        timeRemaining = isBreakTime ? breakDuration : pomodoroDuration
        showAlert = true
        playSound()
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
    
    func resetTimer() {
        stopTimer()
        timeRemaining = pomodoroDuration // Reset duration
        timerStarted = false
    }
    
    func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "reception-bell-14620", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Couldn't load the sound file")
        }
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
                timeRemaining = pomodoroDuration
                timerStarted = false
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Time's Up!"),
                message: Text("The Pomodoro timer has finished."),
                dismissButton: .default(Text("OK")) {
                            self.resetTimer()
                }
            )
        }
        .background(isBreakTime ? Color.green : Color(red: 0.9, green: 0.2, blue: 0.1, opacity: 0.9))
    }
}




#Preview {
    ContentView()
}
