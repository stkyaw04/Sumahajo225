//
//  Test.swift
//  Sumahajo
//
//  Created by Su Thiri Kyaw on 4/7/25.
// This file is purely for testing Tortoise Sprite movement through word count changes which is simulated by pushing a button

import SwiftUI

struct TortoiseAnimationView: View {
    @State private var positionX: CGFloat = 10
    @State private var positionY: CGFloat = 200
    @State private var currentFrame: Int = 1

    let frames = ["Frame1", "Frame2", "Frame3"]

    var body: some View {
        VStack {
            Image(frames[currentFrame - 1]) 
                .scaledToFit()
                .frame(width: 800, height: 300)
                .position(x: positionX, y: positionY)
                .onAppear {
                    // Move image and rotate through frames
                    withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                        positionX = 1400
                    }
                    
                    // Change frames every 7 seconds (you can adjust the time)
                    Timer.scheduledTimer(withTimeInterval: 0.30, repeats: true) { _ in
                        currentFrame = currentFrame % 3 + 1 // Rotate between 1, 2, 3
                    }
                }
        }
    }
}

#Preview {
    TortoiseAnimationView()
}
