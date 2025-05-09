//
//  ContentView.swift
//  Sumahajo
//
//  Created by Su Thiri Kyaw on 4/7/25.
//

import SwiftUI
import AppKit
import ConfettiSwiftUI
import Pow

struct ContentView: View {
    @State private var userText: String = ""
    @State private var wordCount: Int = 0
    @State private var turtleProgress: CGFloat = 0.0
    @State private var hareProgress: CGFloat = 0.0
    @State private var hareWordCount: Int = 0
    @State private var lastTypedTime = Date()
    @State private var timer: Timer?
    @State private var gameOver: Bool = false
    @State private var fontSize: CGFloat = 16
    @State private var showingNameInput = false
    @State private var draftName: String = ""
    @State private var showLibrary = false
    @State private var confettiTrigger = 0
    @State private var hasCelebrated = false

    @Binding var showContentView: Bool
    @Binding var wordGoal: Int
    @ObservedObject var noteViewModel: NoteViewModel
    @StateObject private var hareLogic = HareLogicManager()

    let difficulty: String

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView
                mainContent
                    .zIndex(1)
            }
            .confettiCannon(
                trigger: $confettiTrigger,
                num: 200,
                confettiSize: 20,
                radius: 500,
                repetitions: 1
            )
            .sheet(isPresented: $showingNameInput, content: { draftNamingSheet })
            .navigationDestination(isPresented: $showLibrary) { StartScreenViewWrapper }
            .onAppear {
                hareLogic.configure(difficulty: difficulty, wordGoal: wordGoal)
                hareLogic.start()
            }
            .onReceive(hareLogic.$hareProgress) { value in
                hareWordCount = Int(min(value, CGFloat(wordGoal)))
            }
        }
    }

    // MARK: - Components

    private var backgroundView: some View {
        Image("Background")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .opacity(0.9)
    }

    private var mainContent: some View {
        VStack {
            Spacer(minLength: 150)
            titleSection
            wordCounterSection
            fontSizeControls
            textEditorView
            Spacer(minLength: 250)
            progressBars
        }
        .padding()
    }

    private var titleSection: some View {
        VStack(spacing: 5) {
            Text("Draft Race")
                .font(.title)
                .bold()
                .foregroundColor(hareLogic.userHasWon ? .green : (hareLogic.gameOver ? .red : .primary))

            if hareLogic.gameOver {
                Text(hareLogic.userHasWon ? "You won! Great job" : "Game Over! The hare won.")
                    .font(.headline)
                    .foregroundColor(hareLogic.userHasWon ? .green : .red)
            }
        }
    }

    private var wordCounterSection: some View {
        HStack {
            Text("Word Count: \(wordCount)/\(wordGoal)").bold()
            Spacer()
            Button("Save Your Draft") {
                showingNameInput = true
            }
            .font(.title)
            .padding()
            .disabled(wordCount < wordGoal || (hareLogic.gameOver && !hareLogic.userHasWon))
            .buttonStyle(PushDownButtonStyle())
        }
        .padding()
    }

    private var progressBars: some View {
        ZStack {
            RaceAnimationView(wordGoal: wordGoal, wordCount: $wordCount, isTortoise: true)
            RaceAnimationView(wordGoal: wordGoal, wordCount: .constant(hareWordCount), isTortoise: false)
        }
    }

    private var fontSizeControls: some View {
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
    }

    private var textEditorView: some View {
        TextEditor(text: $userText)
            .font(.system(size: fontSize))
            .lineSpacing(5)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .frame(height: 300)
            .padding(10)
            .background(Color.white.opacity(0.15))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1.5)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .padding()
            .disabled(hareLogic.gameOver && !hareLogic.userHasWon)
            .onChange(of: userText) { _ in updateWordCount() }
    }

    private var draftNamingSheet: some View {
        VStack(spacing: 20) {
            Text("Name Your Draft")
                .font(.headline)

            TextField("Draft Name", text: $draftName)
                .textFieldStyle(.roundedBorder)
                .padding()

            HStack(spacing: 20) {
                Button("Cancel") {
                    showingNameInput = false
                    draftName = ""
                }
                .foregroundColor(.red)

                Button("Save") {
                    noteViewModel.saveDraft(text: userText, fileName: draftName)
                    showingNameInput = false
                    draftName = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showContentView = false
                        showLibrary = true
                    }
                }
                .disabled(draftName.isEmpty)
            }
        }
        .padding()
        .presentationDetents([.height(200)])
    }

    private var StartScreenViewWrapper: some View {
        StartScreenUIView(
            showContentView: $showContentView,
            wordGoal: $wordGoal,
            timedMode: .constant(false),  // no longer used make it false
            difficulty: .constant(difficulty),
            viewModel: noteViewModel
        )
    }

    private func updateWordCount() {
        let words = userText.split { $0.isWhitespace || $0.isNewline }
        wordCount = words.count
        lastTypedTime = Date()
        hareLogic.updateLastTypedTime()
        turtleProgress = CGFloat(wordCount) / CGFloat(wordGoal)

        if wordCount >= wordGoal && !hasCelebrated {
            hasCelebrated = true
            timer?.invalidate()
            confettiTrigger += 1
            hareLogic.userFinished()
        }
    }
}

struct PushDownButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            .foregroundStyle(.white)
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            .background(
                isEnabled ? Color.green : Color.gray.opacity(0.4), in: Capsule()
            )
            .opacity(configuration.isPressed ? 0.75 : 1)
            .conditionalEffect(.pushDown, condition: configuration.isPressed)
    }
}
