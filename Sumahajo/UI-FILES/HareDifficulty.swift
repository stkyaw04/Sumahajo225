import Foundation
import SwiftUI

class HareLogicManager: ObservableObject {
    @Published var hareProgress: CGFloat = 0
    @Published var gameOver: Bool = false
    @Published var userHasWon: Bool = false

    private var chaseTimer: Timer?
    private var idleDetectionTimer: Timer?

    private var difficulty: String = ""
    private var wordGoal: Int = 50

    private var idleDelay: TimeInterval = 10.0
    private var chaseInterval: TimeInterval = 2.0

    func configure(difficulty: String, wordGoal: Int) {
        self.difficulty = difficulty.lowercased()
        self.wordGoal = wordGoal
        self.userHasWon = false
        self.gameOver = false
        self.hareProgress = 0
        stopAllTimers()
        configureDifficultyTimings()
    }

    func start() {
        // Nothing happens at start
    }

    func stop() {
        stopAllTimers()
    }

    func userFinished() {
        guard !userHasWon && !gameOver else { return }
        userHasWon = true
        gameOver = true
        stopAllTimers()
    }

    func updateLastTypedTime() {
        guard !gameOver && !userHasWon else { return }
        stopChaseTimer()
        resetIdleDetectionTimer()
    }

    private func configureDifficultyTimings() {
        switch difficulty {
        case "easy":
            idleDelay = 10
            chaseInterval = 2.0
        case "medium":
            idleDelay = 5
            chaseInterval = 1.5
        case "hard":
            idleDelay = 1
            chaseInterval = 1.0
        default:
            idleDelay = 10
            chaseInterval = 2.0
        }
    }

    private func resetIdleDetectionTimer() {
        idleDetectionTimer?.invalidate()
        idleDetectionTimer = Timer.scheduledTimer(withTimeInterval: idleDelay, repeats: false) { _ in
            self.startChaseTimer()
        }
    }

    private func startChaseTimer() {
        stopChaseTimer()
        chaseTimer = Timer.scheduledTimer(withTimeInterval: chaseInterval, repeats: true) { _ in
            DispatchQueue.main.async {
                guard !self.gameOver && !self.userHasWon else { return }
                self.hareProgress = min(self.hareProgress + 1, CGFloat(self.wordGoal))
                if self.hareProgress >= CGFloat(self.wordGoal) {
                    self.gameOver = true
                    self.stopAllTimers()
                }
            }
        }
    }

    private func stopChaseTimer() {
        chaseTimer?.invalidate()
        chaseTimer = nil
    }

    private func stopAllTimers() {
        chaseTimer?.invalidate()
        idleDetectionTimer?.invalidate()
        chaseTimer = nil
        idleDetectionTimer = nil
    }
}
