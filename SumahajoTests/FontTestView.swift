
// FontTestView.swift
// Sumahajo
//
// Created by Harold Ponce on 4/29/25.
//
import SwiftUI
import AppKit

struct FontTestView: View {
  init() {
    for family in NSFontManager.shared.availableFontFamilies {
      print("Family: \(family)")
    }
  }
  var body: some View {
    Text("Hello with FatPix!")
      .font(.custom("FatPix-Regular", size: 32))
  }
  #Preview {
    FontTestView()
  }
}




