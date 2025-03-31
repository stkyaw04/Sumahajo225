//
//  AppRootView.swift
//  Sumahajo
//
//  Created by Harold Ponce on 3/28/25.
//

import SwiftUI

struct ViewController: View {
    @State private var showContentView = false
    @State private var wordGoal: Int = 50
    
    var body: some View {
        
        if showContentView {
            ContentView(wordGoal: wordGoal)
        }else{
            StartScreenUIView(showContentView : $showContentView, wordGoal: $wordGoal)
        }
    }
}

#Preview {
    ViewController()
}
