//
//  StartScreenUIView.swift
//  Sumahajo
//
//  Created by Harold Ponce on 3/28/25.
//

import SwiftUI

struct StartScreenUIView: View {
    @Binding var showContentView: Bool // Must be a binding

    var body: some View {
        VStack{
        Text("Welcome to Tortoise vs Hare")
                .font(.largeTitle)
                .padding()
                Button("Start Game") {
                showContentView = true
                    }
                    .font(.title)
                    .padding()
                }
        }
}
#Preview {
    StartScreenUIView(showContentView: .constant(false))
}
