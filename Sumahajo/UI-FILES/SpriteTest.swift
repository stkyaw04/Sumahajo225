import SwiftUI

struct SpriteTest: View {
    @State private var positionX: CGFloat = 10
    @State private var positionY: CGFloat = 200
    @State private var currentFrame: Int = 1

    let frames = ["Frame1", "Frame2", "Frame3"]

    var body: some View {
        VStack {
            Image(frames[currentFrame - 1]) // Display the current frame
//                .resizable()
                .scaledToFit()
                .frame(width: 800, height: 300)
                .position(x: positionX, y: positionY)
                .onAppear {
                    // Move image and rotate through frames
                    withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                        positionX = 1000
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
    SpriteTest()
}
