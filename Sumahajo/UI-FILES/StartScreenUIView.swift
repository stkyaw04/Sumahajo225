//
//  StartScreenUIView.swift
//  Sumahajo
//
//  Created by Harold Ponce on 3/28/25.
//

import SwiftUI
import Foundation


struct DraftFile: Identifiable {
    let id = UUID()
    let name: String
}


struct StartScreenUIView: View {
    @Binding var showContentView: Bool
    @Binding var wordGoal: Int
    @State private var inputText: String = ""
    @State private var errorMessage : String? = nil
    @Binding var timedMode: Bool
    @Binding var difficulty: String
    let difficulties = ["Easy","Medium","Hard"]
    
    @ObservedObject var viewModel: NoteViewModel
    @State private var searchText = ""
    @State private var showStartScreen = false
    @State private var splitPosition: CGFloat = 300
    @State private var selectedFile: DraftFile? = nil
    @State private var navigateToEdit: Bool = false
    @State private var editingFileName: String = ""
    
   
    
    var filteredFiles: [String] {
        if searchText.isEmpty {
            return viewModel.files
        }
        return viewModel.files.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("StartPage")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.9)
                TortoiseAnimationView()
                    .offset(x:0, y:625)
                
                HStack{
                    if !viewModel.files.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Spacer().frame(height: 100)
                            
                            TextField("Search", text: $searchText)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                                .padding(.top, 40)
                            
                            List(filteredFiles, id: \.self) { file in
                                HStack {
                                    Button(file) {
                                        editingFileName = file
                                        navigateToEdit = true
                                    }
                                    .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button("Delete") {
                                        viewModel.deleteFile(named: file)
                                    }
                                    .foregroundColor(.red)
                                }
                                .listRowBackground(Color.clear)
                            }
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                        }
                        .background(Color.black.opacity(0.3))// can also be ".ultraThinMaterial"
                        .cornerRadius(12)
                        .padding(.top, 10)
                        .frame(width: splitPosition)
                        .onAppear {
                            viewModel.loadFiles()
                        }
                    }
                    
                
                VStack{
                    Text("Welcome to Tortoise and Hare")
                        .font(.pixelFont())
                        .frame(width: 1000)
                        .padding()
                    
                    HStack{
                        Picker("Difficulty", selection: $difficulty){
                            ForEach(difficulties, id: \.self){
                                level in Text(level)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 600)
                    }
//                    Toggle("Timer", isOn: $timedMode)
//                        .frame(width: 300)
//                        .padding()
                    
                    TextField("Enter a word goal", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit(startGame)
                        .frame(width:600)
                        .padding()
                    
                    if let errorMessage = errorMessage{
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                    Button("Start Writing") {
                        
                        startGame()
                    }
                    .font(.title)
                    .padding()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationDestination(isPresented: $navigateToEdit) {
            EditDraftView(viewModel: viewModel, file: editingFileName)
        }
    }
}
        func startGame() {
            if let goal = Int(inputText), goal > 0 {
                wordGoal = goal
                showContentView = true
                print("Game Started with goal: \(goal), difficulty: \(difficulty), timed: \(timedMode)")
            } else {
                errorMessage = "Please input a valid word goal"
            }
        }
    }




//EDITDRAFT VIEW UI

struct EditDraftView: View {
    @ObservedObject var viewModel: NoteViewModel
    let file: String

    @Environment(\.dismiss) private var dismiss
    @State private var fontSize: CGFloat = 16
    @State private var wordCount: Int = 0

    var body: some View {
        ZStack {
            Image("StartPage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.9)

            VStack(spacing: 20) {
                Spacer(minLength: 10)

                Text("Edit Your Draft")
                    .font(.title)
                    .bold()

                Text("Word Count: \(wordCount)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))

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

                TextEditor(text: $viewModel.fileContent)
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
                    .onChange(of: viewModel.fileContent) { _ in
                        updateWordCount()
                    }

                Button("Save Changes") {
                    viewModel.saveFile()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        dismiss()
                    }
                }
                .font(.title3)
                .padding()
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            loadFile()
            updateWordCount()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }

    private func loadFile() {
        viewModel.currentFileName = file
        let fileURL = viewModel.documentsURL.appendingPathComponent(file)
        do {
            viewModel.fileContent = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            print("Failed to open file: \(error)")
        }
    }

    private func updateWordCount() {
        let words = viewModel.fileContent.split { $0.isWhitespace || $0.isNewline }
        wordCount = words.count
    }
}



//
//#Preview {StartScreenUIView(showContentView: .constant(false),wordGoal: .constant(0),timedMode: .constant(false),difficulty: .constant("Easy")
//)
//}
