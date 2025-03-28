//
//  AppRootView.swift
//  Sumahajo
//
//  Created by Harold Ponce on 3/28/25.
//

import SwiftUI

struct ViewController: View {
    @State private var showContentView = false
    
    var body: some View {
        
        if showContentView {
            ContentView()
        }else{
            StartScreenUIView(showContentView : $showContentView)
        }
    }
}

#Preview {
    ViewController()
}
