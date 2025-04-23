//
//  ProgressBar.swift
//  Sumahajo
//
//  Created by Joseph Saputra on 3/26/25.
//

import SwiftUI

struct ProgressBar: View {
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

    let tortoiseFrames = ["Tortoise1", "Tortoise2", "Tortoise3"]
    let hareFrames = ["Hare1", "Hare2", "Hare3", "Hare4"]

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
//                Rectangle()
//                    .frame(height: 10)
//                    .foregroundColor(.gray.opacity(0.3))
//                    .cornerRadius(5)

//                Rectangle()
//                    .frame(
//                        width: min(CGFloat(wordCount) / CGFloat(wordGoal) * geometry.size.width, geometry.size.width),
//                        height: 10
//                    )
//                    .foregroundColor(isTortoise ? .green : .red)
//                    .cornerRadius(5)

                Image((isTortoise ? tortoiseFrames : hareFrames)[currentFrame - 1])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .position(
                        x: isTortoise ? tortoisePosition : harePosition,
                        y: -10
                    )
            }
            .onChange(of: wordCount) { newValue in
                let step = geometry.size.width / CGFloat(wordGoal)
                targetPosition = CGFloat(newValue) * step

                walkTask?.cancel()
                startWalking()
            }
        }
//        .padding(.top, 40)
    }

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

                let currentPos = isTortoise ? tortoisePosition : harePosition
                let distance = targetPosition - currentPos
                let move = min(abs(distance), (isTortoise ? tortoiseSpeed : hareSpeed) / 25.0) * (distance < 0 ? -1 : 1)

                if isTortoise {
                    tortoisePosition += move
                } else {
                    withAnimation(.easeOut(duration: 0.1)) {
                        harePosition += move
                    }
                }

                lastFrameUpdate += 1
                if lastFrameUpdate % 6 == 0 {
                    currentFrame = (currentFrame % 3) + 1
                }
            }

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
