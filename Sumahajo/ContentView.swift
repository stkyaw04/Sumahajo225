import SwiftUI

struct ContentView: View {
    // Variables
    @State private var userText: String = ""
    @State private var wordCount: Int = 0
    @State private var turtleProgress: CGFloat = 0.0
    @State private var hareProgress: CGFloat = 0.0
    @State private var lastTypedTime = Date()
    @State private var timer: Timer?
    @State private var gameOver: Bool = false
    let wordGoal = 50
    
    var body: some View {
        ZStack {
            Image("wallpaper")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.9)
        }
        
        VStack(spacing: 20) {
            Text("Typing Race")
                .font(.title)
                .bold()
                .foregroundColor(gameOver ? .red : .primary)
            
            if gameOver {
                Text("Game Over! The hare won.")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            HStack {
                Text("Word Count: \(wordCount)/\(wordGoal)")
                Spacer()
                Button("Save") {
                    saveDraft()
                }
                .disabled(wordCount < wordGoal || gameOver)
            }
            .padding()
            
            ProgressBar(progress: CGFloat(wordCount) / CGFloat(wordGoal), color: .green)
            ProgressBar(progress: hareProgress / CGFloat(wordGoal), color: .red)
            
            TextEditor(text: $userText)
                .frame(height: 200)
                .border(Color.gray, width: 1)
                .padding()
                .onChange(of: userText) { _ in
                    updateWordCount()
                }
                .disabled(gameOver)
            
            Spacer()
        }
        .padding()
        .onAppear(perform: startHareTimer)
    }
    
    func updateWordCount() {
        let words = userText.split { $0.isWhitespace || $0.isNewline }
        wordCount = words.count
        lastTypedTime = Date()
        
        // Normalize progress
        turtleProgress = CGFloat(wordCount) / CGFloat(wordGoal)
        
        if wordCount >= wordGoal {
            timer?.invalidate()
        }
    }
    
    func startHareTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let timeElapsed = Date().timeIntervalSince(lastTypedTime)
            
            if timeElapsed >= 10 {
                hareProgress += 1 // Hare moves by 1 word unit every second of inactivity
            }
            
            if hareProgress >= CGFloat(wordGoal) {
                timer?.invalidate()
                gameOver = true
                userText = "" // Clear text when hare wins
            }
        }
    }
    
    func saveDraft() {
        print("Draft saved: \(userText)")
    }
}

struct ProgressBar: View {
    var progress: CGFloat
    var color: Color
    
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
            }
        }
        .frame(height: 10)
    }
}

#Preview {
    ContentView()
}
