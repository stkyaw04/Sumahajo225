//
//  HareDifficulty.swift
//  Sumahajo
//
//  Created by Harold Ponce on 4/21/25.
//  This file allows the user to change the difficulty of their typing using a timer or by making the hare way faster allowing the use to have a hard mode. Handles hare timing, progress, and difficulty logic

import Foundation
import SwiftUI
class HareLogicManager: ObservableObject {
    @Published var hareProgress: CGFloat = 0
    @Published var timeRemaining: Int = 0
    @Published var gameOver: Bool = false
    private var timer: Timer?
    private var lastTypedTime = Date()
    private var isTimedMode = false
    private var difficulty: String = ""
    private var wordGoal: Int = 50

    func configure(timedMode: Bool, difficulty: String, wordGoal: Int) {
        self.isTimedMode = timedMode
        self.difficulty = difficulty
        self.wordGoal = wordGoal
    }

    func start() {
        if isTimedMode {
            startHareCountDown()
        } else {
            startHareChase()
        }
    }

    func updateLastTypedTime() {
        lastTypedTime = Date()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func startHareChase() {
        timer = Timer.scheduledTimer(withTimeInterval: hareSpeedMultiplier(), repeats: true) { _ in
            if self.gameOver { return }

            let elapsed = Date().timeIntervalSince(self.lastTypedTime)
            if elapsed >= 2 {
                DispatchQueue.main.async {
                    self.hareProgress = min(self.hareProgress + 1, CGFloat(self.wordGoal))
                    if self.hareProgress >= CGFloat(self.wordGoal) {
                        self.stop()
                        self.gameOver = true
                    }
                }
            }
        }
    }

     func startHareCountDown() {
        timeRemaining = initialTimeForDifficulty()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.gameOver { return }

            DispatchQueue.main.async {
                self.timeRemaining -= 1
                if self.timeRemaining <= 0 {
                    self.stop()
                    self.gameOver = true
                }
            }
        }
    }

    // Controls how fast the hare *ticks* in seconds per step
    func hareSpeedMultiplier() -> Double {
        switch difficulty.lowercased() {
        case "easy": return 2.0   // slower
        case "medium": return 1.5
        case "hard": return 1   // faster
        default: return 2.0
        }
    }

    private func initialTimeForDifficulty() -> Int {
        switch difficulty.lowercased() {
        case "easy": return 5 * wordGoal
        case "medium": return 2 * wordGoal
        case "hard": return 1 * wordGoal
        default: return 10
        }
    }
}
