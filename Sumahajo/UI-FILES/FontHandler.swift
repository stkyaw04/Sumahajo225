//
//  FontHandler.swift
//  Sumahajo
//
//  Created by Harold Ponce on 4/29/25.
// this allows the use of fonts when adding them in this file
// if you dont understand this code watch this video https://www.youtube.com/watch?v=JB__8NzFadg "Add Custom Fonts to Your iOS App | SwiftUI"

import SwiftUI

extension Font {
    static func pixelfont() -> Font{
        return Font.custom("BalooBhaijaan-Regular", size: 64)
    }
}
