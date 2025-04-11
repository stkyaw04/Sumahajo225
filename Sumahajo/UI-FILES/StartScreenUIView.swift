//
//  StartScreenUIView.swift
//  Sumahajo
//
//  Created by Harold Ponce on 3/28/25.
//

import SwiftUI

struct StartScreenUIView: View {
    @Binding var showContentView: Bool // Must be a binding
    @Binding var wordGoal: Int
    @State private var inputText: String = ""
    @State private var errorMessage : String? = nil
    
    var body: some View {
        ZStack{
            Image("StartPage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.9)
            SpriteTest()
                .offset(x:0, y:625)
            VStack{
                Text("Welcome to Tortoise vs Hare")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Enter a word goal", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit(startGame)
                    .frame(width:500)
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
            
        }
    }
        func startGame() {
            if let goal = Int(inputText), goal > 0 {
                wordGoal = goal
                showContentView = true
            } else {
                errorMessage = "Please input a valid word goal"
            }
        }
    }
#Preview {
    StartScreenUIView(showContentView: .constant(false), wordGoal: .constant(0))
}
