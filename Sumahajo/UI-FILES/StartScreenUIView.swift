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

    var body: some View {
        VStack{
        Text("Welcome to Tortoise vs Hare")
                .font(.largeTitle)
                .padding()
            
            TextField("Enter a word goal", text: $inputText)
                //.onSubmit(startGame) - this is if i create a func that starts the game based on an imput
                .frame(width:500)
                .padding()

                Button("Start Writing") {
                wordGoal = Int(inputText) ?? 50
                showContentView = true
                    }
                    .font(.title)
                    .padding()
                }
        }
}
#Preview {
    StartScreenUIView(showContentView: .constant(false), wordGoal: .constant(50))
}
