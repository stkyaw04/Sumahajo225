//
//  AppRootView.swift
//  Sumahajo
//
//  Created by Harold Ponce on 3/28/25.
//

import SwiftUI

struct ViewController: View {
    @State private var showContentView = false
    @State private var wordGoal: Int = 0
    @State private var timedMode: Bool = false
    @State private var difficulty: String = "Easy"

    var body: some View {
        if showContentView {
            ContentView(
                wordGoal: wordGoal,
                timedMode: timedMode,
                difficulty: difficulty
            )
        } else {
            StartScreenUIView(
                showContentView: $showContentView,
                wordGoal: $wordGoal,
                timedMode: $timedMode,
                difficulty: $difficulty
            )
        }
    }
}


#Preview {
    ViewController()
}
