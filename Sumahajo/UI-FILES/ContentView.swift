import SwiftUI
import AppKit

struct ContentView: View {
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
            
            VStack(spacing: 20) {
                Spacer(minLength: 10)
                
                Text("Tortoise vs Hare")
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
                        DraftSaver.saveDraft(text: userText)
                    }
                    .disabled(wordCount < wordGoal || gameOver)
                }
                .padding()
                
                ProgressBar(progress: turtleProgress, color: .green)
                ProgressBar(progress: hareProgress / CGFloat(wordGoal), color: .red)
                
                TextEditor(text: $userText)
                    .frame(height: 500)
                    .border(Color.gray, width: 1)
                    .padding()
                    .onChange(of: userText) { _ in
                        DispatchQueue.main.async {
                            updateWordCount()
                        }
                    }
                    .disabled(gameOver)
                
                Spacer()
            }
            .padding()
            .onAppear(perform: startHareTimer)
        }
    }
    
    func updateWordCount() {
        let words = userText.split { $0.isWhitespace || $0.isNewline }
        wordCount = words.count
        lastTypedTime = Date()
        
        // Update turtle progress
        turtleProgress = CGFloat(wordCount) / CGFloat(wordGoal)
        
        // Stop timer if the goal is met
        if wordCount >= wordGoal {
            DispatchQueue.main.async {
                timer?.invalidate()
            }
        }
    }
    
    func startHareTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let timeElapsed = Date().timeIntervalSince(lastTypedTime)
            
            DispatchQueue.main.async {
                if timeElapsed >= 10 {
                    hareProgress += 1
                }
                
                if hareProgress >= CGFloat(wordGoal) {
                    timer?.invalidate()
                    gameOver = true
                }
            }
        }
    }
}



#Preview {
    ContentView()
}
