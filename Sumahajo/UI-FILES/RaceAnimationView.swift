//
//  RaceAnimationView.swift
//
//  Created by Su Thiri Kyaw on 3/26/25.
//  Handles the sprite animation movements for both the tortoise and the hare

import SwiftUI

struct RaceAnimationView: View {
    var wordGoal: Int
    @Binding var wordCount: Int
    var isTortoise: Bool

    @State private var tortoisePosition: CGFloat = 0
    @State private var harePosition: CGFloat = 0

    @State private var targetPosition: CGFloat = 0
    @State private var currentFrame: Int = 1
    @State private var isWalking = false
    @State private var walkTask: Task<Void, Never>? = nil
    @State private var isAnimating = false
    @State private var maxWordCount: Int = 0

    let tortoiseFrames = ["Tortoise1", "Tortoise2", "Tortoise3"]
    let hareFrames = ["Hare1", "Hare2", "Hare3", "Hare4"]

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Display current sprite frame based on character type and animation frame
                Image((isTortoise ? tortoiseFrames : hareFrames)[currentFrame - 1])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .position(
                        x: isTortoise ? tortoisePosition : harePosition,
                        y: -10 // adjust vertical alignment as needed
                    )
            }
            // When wordCount increases, update the target position and trigger animation
            .onChange(of: wordCount) { newValue in
                if newValue > maxWordCount {
                        maxWordCount = newValue
                        
                        // Calculate horizontal step size per word
                        let step = geometry.size.width / CGFloat(wordGoal)
                        targetPosition = CGFloat(newValue) * step

                        // Cancel any existing walk animation task before starting a new one to avoid any glitches or running multiple sequences
                        walkTask?.cancel()
                        startWalking()
                }
            }
        }
    }

    /// Starts the walking animation toward the current target position.
    /// Moves the character in small increments and updates frames to simulate walking.
    func startWalking() {
        isAnimating = true
        startAnimatingFrames()
        
        walkTask = Task {
            let frameDuration: UInt64 = 1_000_000_000 / 25
            let tortoiseSpeed: CGFloat = 40
            let hareSpeed: CGFloat = 100

            var lastFrameUpdate = 0

            while !Task.isCancelled && abs((isTortoise ? tortoisePosition : harePosition) - targetPosition) > 0.5 {
                try? await Task.sleep(nanoseconds: frameDuration)

                // Compute how much to move this frame
                let currentPos = isTortoise ? tortoisePosition : harePosition
                let distance = targetPosition - currentPos
                let move = min(abs(distance), (isTortoise ? tortoiseSpeed : hareSpeed) / 25.0) * (distance < 0 ? -1 : 1)

                // Apply movement to specific character
                if isTortoise {
                    tortoisePosition += move
                } else {
                    withAnimation(.easeOut(duration: 0.1)) {
                        harePosition += move
                    }
                }

                // Update frame every 6 ticks (~4 frames per second for step cycle)
                lastFrameUpdate += 1
                if lastFrameUpdate % 6 == 0 {
                    currentFrame = (currentFrame % 3) + 1
                }
            }

            // Stop exactly at target when animation ends
            if !Task.isCancelled {
                if isTortoise {
                    tortoisePosition = targetPosition
                } else {
                    withAnimation(.easeOut(duration: 0.1)) {
                        harePosition = targetPosition
                    }
                }
            }
            
            isAnimating = false
        }
    }
    
    /// Loops through sprite frames to simulate walking while the character is moving.
    func startAnimatingFrames() {
        Task {
            while isAnimating {
                try? await Task.sleep(nanoseconds: 120_000_000) // ~0.24s per frame
                currentFrame = (currentFrame % 3) + 1
            }
        }
    }
}

//#Preview {
//    ProgressBar(wordGoal: 100)  // Pass custom values to preview
//}
