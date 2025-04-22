import SwiftUI
import AppKit

struct ContentView: View {
    @State private var userText: String = ""
    @State private var wordCount: Int = 0
    @State private var turtleProgress: CGFloat = 0.0
    @State private var hareProgress: CGFloat = 0.0
    @State private var hareWordCount: Int = 0
    @State private var lastTypedTime = Date()
    @State private var timer: Timer?
    @State private var gameOver: Bool = false
    @State private var fontSize: CGFloat = 16  // to Add font size state
    @State private var timeRemaining: Int = 60 // default, can adjust based on difficulty
    @StateObject private var hareLogic = HareLogicManager()
    
    let wordGoal: Int
    let timedMode: Bool
    let difficulty: String
    
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
                if timedMode{
                    Text("Time Remaining: \(hareLogic.timeRemaining)s")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                if hareLogic.gameOver {
                    Text(timedMode ? "Time’s up! The hare wins." : "Game Over! The hare won.")
                        .font(.headline)
                        .foregroundColor(.red)
                }
                
                HStack {
                    if !timedMode {
                        Text("Word Count: \(wordCount)/\(wordGoal)")
                    } else {
                        Text("Words Written: \(wordCount)")
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        DraftSaver.saveDraft(text: userText)
                    }
                    .disabled((!timedMode && wordCount < wordGoal) || hareLogic.gameOver)
                }
                .padding()
                
                //                ProgressBar(progress: turtleProgress, color: .green, isTortoise: true)
                //                ProgressBar(progress: hareProgress / CGFloat(wordGoal), color: .red, isTortoise: false)
                
                ProgressBar(wordGoal: wordGoal, wordCount: $wordCount, isTortoise: true)
                ProgressBar(wordGoal: wordGoal, wordCount: .constant(hareWordCount), isTortoise: false)
                
                // This HStack allows the user to adjust the font size of the TextEditor dynamically.
                // Font size adjustment controls:
                // - "-" and "+" buttons decrease/increase fontSize within range 12–28.
                // - Current font size displayed between buttons.
                HStack {
                    Text("Font Size:")
                    
                    Button(action: { fontSize = max(12, fontSize - 2) }) {
                        Image(systemName: "minus.circle")
                    }
                    
                    Text("\(Int(fontSize))")
                        .frame(width: 30)
                    
                    Button(action: { fontSize = min(28, fontSize + 2) }) {
                        Image(systemName: "plus.circle")
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // Text editor with adjustable font size and styling:
                // - Applies dynamic font size.
                // - Adds padding, border, rounded corners, and overlay for better UI.
                
                TextEditor(text: $userText)
                    .font(.system(size: fontSize)) //to applied custom font size
                    .frame(height: 500)
                    .padding(10)          //added internal padding
                    .border(Color(.textBackgroundColor))
                    .cornerRadius(8)    //added a border
                    .overlay(  //  Added a border
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 3) // we can change to color we want here!
                    )
                    .padding()
                    .onChange(of: userText) { _ in
                        DispatchQueue.main.async {
                            updateWordCount()
                        }
                    }
                    .disabled(hareLogic.gameOver)
                
            }
            .padding()
            .onAppear {
                hareLogic.configure(timedMode: timedMode, difficulty: difficulty, wordGoal: wordGoal)
                hareLogic.start()
            }
            .onReceive(hareLogic.$hareProgress) { value in
                hareWordCount = Int(min(value, CGFloat(wordGoal)))
            }
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
}

#Preview {
    //ContentView(wordGoal: 0)
}
