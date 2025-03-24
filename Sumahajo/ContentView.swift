//
//  ContentView.swift
//  Sumahajo 225team

//  Created by Su Thiri Kyaw on 3/10/25.
//
import SwiftUI
struct ContentView: View {
    //Variables
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
                .opacity(0.9) // Increased opacity for visibility
         
                
                .opacity(turtleProgress)
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
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(.gray.opacity(0.3))
                GeometryReader { geometry in
                    Rectangle()
                        .frame(
                            width: min(
                                CGFloat(wordCount) / CGFloat(
                                    wordGoal
                                ) * geometry.size.width,
                                geometry.size.width
                            ),
                            height: 10
                        )
                        .foregroundColor(.green)
                }
            }
            .frame(height: 10) // Ensures correct height
            .cornerRadius(5)
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(.gray.opacity(0.3))
                GeometryReader { geometry in
                    Rectangle()
                        .frame(
                            width: min(
                                hareProgress / CGFloat(
                                    wordGoal
                                ) * geometry.size.width,
                                geometry.size.width
                            ),
                            height: 10
                        )
                        .foregroundColor(.red)
                }
            }
            .frame(height: 10)
            .cornerRadius(5)
            TextEditor(text: $userText)
                .frame(height: 400)
                .border(Color.gray, width: 1)
                .padding()
                .onChange(of: userText) { _ in
                    updateWordCount()
                }
                .disabled(gameOver)// Turning off the typing func
            Spacer()
        }
        .padding()
        //.background(Color.white.opacity(0.08))
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
        timer = Timer
            .scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                let timeElapsed = Date().timeIntervalSince(lastTypedTime)
                if timeElapsed >= 10 {
                    hareProgress += 1 // Hare moves by 1 word unit every second of inactivity
                }
                if hareProgress >= CGFloat(wordGoal) {
                    timer?.invalidate()
                    gameOver = true
                    userText = "" // clear text when hare wins
                }
            }
    }
    func saveDraft() {
        //Saving function to be implemented
        print("Draft saved: \(userText)")
    }
}

