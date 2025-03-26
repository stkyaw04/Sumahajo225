//
//  ProgressBar.swift
//  Sumahajo
//
//  Created by Joseph Saputra on 3/26/25.
//

import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat
    var color: Color
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 10)
                .foregroundColor(.gray.opacity(0.3))
                .cornerRadius(5)
            
            GeometryReader { geometry in
                Rectangle()
                    .frame(
                        width: min(progress * geometry.size.width, geometry.size.width),
                        height: 10
                    )
                    .foregroundColor(color)
                    .cornerRadius(5)
            }
        }
        .frame(height: 10)
    }
}

