//
//  FontHandler.swift
//  Sumahajo
//
//  Author: Harold Ponce on 4/28/25.
//  For how to add more fonts https://www.youtube.com/watch?v=JB__8NzFadg
//  pixelFont allows custom Fonts to be used and called by other functions
//  

import SwiftUI
import AppKit

extension Font {
    static func pixelFont() -> Font {
        return Font.custom("FatPix-Regular", size: 64)
    }
}
