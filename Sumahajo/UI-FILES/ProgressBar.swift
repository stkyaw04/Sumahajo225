//
//  ProgressBar.swift
//  Sumahajo
//
//  Created by Joseph Saputra on 3/26/25.
//

import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat
    var color: Color
    
    var isTortoise: Bool = false
    var wordCount: Int // Accept word count to trigger animation
    
    @State private var currentFrame: Int = 1
    @State private var positionX: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 10)
                .foregroundColor(.gray.opacity(0.3))
                .cornerRadius(5)
            
            GeometryReader { geometry in
                Rectangle()
                    .frame(
                        width: min(progress * geometry.size.width, geometry.size.width),
                        height: 10
                    )
                    .foregroundColor(color)
                    .cornerRadius(5)
                
                if isTortoise {
                                        let frames = ["Tortoise1", "Tortoise2", "Tortoise3"]
                                        Image(frames[currentFrame - 1])
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 70, height: 70)
                                            .position(x: min(progress * geometry.size.width, geometry.size.width), y: -10)
                                            .onChange(of: wordCount) { _ in
                                                animateTortoise()
                                            }
                                    }
            }
        }
        .frame(height: 10)
    }
    
    func animateTortoise() {
        var frameIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            currentFrame = (currentFrame % 3) + 1
            frameIndex += 1
            
            if frameIndex >= 3 {
                timer.invalidate() 
            }
        }
    }
}

