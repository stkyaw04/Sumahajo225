//
//  DraftSaver.swift
//  Sumahajo
//
//  Created by Joseph Saputra on 3/26/25.
//

import Foundation
import AppKit

class DraftSaver {
    static func saveDraft(text: String) {
        let savePanel = NSSavePanel()
        savePanel.title = "Save Your Draft"
        savePanel.nameFieldStringValue = "TypingRaceDraft.txt"
        savePanel.allowedFileTypes = ["txt"]
        
        if savePanel.runModal() == .OK, let url = savePanel.url {
            do {
                try text.write(to: url, atomically: true, encoding: .utf8)
                print("File saved successfully at \(url.path)")
            } catch {
                print("Error saving file: \(error.localizedDescription)")
            }
        }
    }
}

