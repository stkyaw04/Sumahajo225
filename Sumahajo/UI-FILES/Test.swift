//
//  Test.swift
//  Sumahajo
//
//  Created by Su Thiri Kyaw on 4/7/25.
//  This file is purely for testing Tortoise Sprite movement through word count changes which is simulated by pushing a button

import SwiftUI

struct AnimationTest: View {
    var wordGoal: Int
    @State private var wordCount: Int = 0
    @State private var tortoisePosition: CGFloat = 0
    @State private var targetPosition: CGFloat = 0
    @State private var currentFrame: Int = 1
    @State private var isWalking = false
    @State private var walkTask: Task<Void, Never>? = nil

    let tortoiseFrames = ["Frame1", "Frame2", "Frame3"]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .leading) {
                    let step: CGFloat = geometry.size.width / CGFloat(wordGoal)

                    Rectangle()
                        .frame(width: geometry.size.width, height: 10)
                        .foregroundColor(.gray.opacity(0.3))
                        .cornerRadius(5)

                    Image(tortoiseFrames[currentFrame - 1])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .position(x: tortoisePosition, y: 110)
                }
                .padding(.top, 50)

                Button("Move Forward") {
                    if wordCount < wordGoal {
                        wordCount += 1
                        let step = geometry.size.width / CGFloat(wordGoal)
                        targetPosition = CGFloat(wordCount) * step

                        if !isWalking {
                            startWalking()
                        }
                    }
                }
                .padding()
            }
        }
    }

    func startWalking() {
        isWalking = true

        walkTask = Task {
            let frameDuration: UInt64 = 1_000_000_000 / 60
            let speed: CGFloat = 30
            var lastFrameUpdate = 0

            while abs(tortoisePosition - targetPosition) > 0.5 {
                try? await Task.sleep(nanoseconds: frameDuration)

                let distance = targetPosition - tortoisePosition
                
                tortoisePosition += min(distance, speed / 60.0)

                lastFrameUpdate += 1
                if lastFrameUpdate % 6 == 0 {
                    currentFrame = (currentFrame % 3) + 1
                }
            }

            tortoisePosition = targetPosition
            isWalking = false
            walkTask = nil
        }
    }
}


#Preview {
    AnimationTest(wordGoal: 20)  // Pass custom values to preview
}
