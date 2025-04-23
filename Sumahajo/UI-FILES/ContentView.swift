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
    @State private var fontSize: CGFloat = 16
    @State private var showingNameInput = false
    @State private var draftName: String = ""
    @State private var showLibrary = false

    @Binding var showContentView: Bool
    @Binding var wordGoal: Int
    @ObservedObject var noteViewModel: NoteViewModel
    @StateObject private var hareLogic = HareLogicManager()

    let timedMode: Bool
    let difficulty: String

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView
                mainContent
            }
            .sheet(isPresented: $showingNameInput, content: { draftNamingSheet })
            .navigationDestination(isPresented: $showLibrary) { StartScreenViewWrapper }
            .onAppear {
                hareLogic.configure(timedMode: timedMode, difficulty: difficulty, wordGoal: wordGoal)
                hareLogic.start()
            }
            .onReceive(hareLogic.$hareProgress) { value in
                hareWordCount = Int(min(value, CGFloat(wordGoal)))
            }
        }
    }

    //  Components

    private var backgroundView: some View {
        Image("wallpaper")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .opacity(0.9)
    }

    private var mainContent: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 20)
            titleSection
            wordCounterSection
//            progressBars
            fontSizeControls
            textEditorView
            progressBars
        }
        .padding()
    }

    private var titleSection: some View {
        VStack(spacing: 5) {
            Text("Tortoise vs Hare")
                .font(.title)
                .bold()
                .foregroundColor(gameOver ? .red : .primary)

            if timedMode {
                Text("Time Remaining: \(hareLogic.timeRemaining)s")
                    .font(.headline)
                    .foregroundColor(.blue)
            }

            if hareLogic.gameOver {
                Text(timedMode ? "Time’s up! The hare wins." : "Game Over! The hare won.")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
    }

    private var wordCounterSection: some View {
        HStack {
            Text(timedMode ? "Words Written: \(wordCount)" : "Word Count: \(wordCount)/\(wordGoal)")
            Spacer()
            Button("Save YOur Draft") {
                showingNameInput = true
            }
            .font(.title)
            .padding()
            .disabled((!timedMode && wordCount < wordGoal) || hareLogic.gameOver)
        }
        .padding()
    }

    private var progressBars: some View {
        VStack {
            ProgressBar(wordGoal: wordGoal, wordCount: $wordCount, isTortoise: true)
            ProgressBar(wordGoal: wordGoal, wordCount: .constant(hareWordCount), isTortoise: false)
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
            .frame(height: 500)
            .padding(10)
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 3)
            )
            .padding()
            .disabled(hareLogic.gameOver)
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
            timedMode: .constant(timedMode),
            difficulty: .constant(difficulty),
            viewModel: noteViewModel
        )
    }



    private func updateWordCount() {
        let words = userText.split { $0.isWhitespace || $0.isNewline }
        wordCount = words.count
        lastTypedTime = Date()
        turtleProgress = CGFloat(wordCount) / CGFloat(wordGoal)

        if wordCount >= wordGoal {
            DispatchQueue.main.async { timer?.invalidate() }
        }
    }
}
