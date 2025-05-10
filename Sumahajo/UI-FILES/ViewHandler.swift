//
//  AppRootView.swift
//  Sumahajo
//
//  Created by Harold Ponce on 3/28/25.
//  It manages the transition between the start screen (StartScreenUIView)
//  and the main writing interface (DraftView).

import SwiftUI

struct ViewHandler: View {
    @State private var showDraftView = false
    @State private var wordGoal: Int = 0
    @State private var timedMode: Bool = false
    @State private var difficulty: String = "Easy"
    @StateObject private var viewModel = NoteViewModel()

    var body: some View {
        if showDraftView {
            DraftView(
                showDraftView: $showDraftView,
                wordGoal: $wordGoal,
                noteViewModel: viewModel,
                difficulty: difficulty
            )
        } else {
            StartScreenUIView(
                showContentView: $showDraftView,
                wordGoal: $wordGoal,
                timedMode: $timedMode,
                difficulty: $difficulty,
                viewModel: viewModel
            )
        }
    }
}
#Preview {
    ViewHandler()
}
