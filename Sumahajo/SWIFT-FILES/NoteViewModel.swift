//
//  NoteViewModel.swift
//  Sumahajo
//
//  Created by Joseph Saputra on 4/22/25.
//
import SwiftUI
import Foundation

class NoteViewModel: ObservableObject {
    @Published var files: [String] = []
    @Published var currentFileName: String = ""
    @Published var fileContent: String = ""
    
    let fileManager = FileManager.default
    let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("NoteShelf")
    
    init() {
        loadFiles()
    }
    
    func loadFiles() {
        do {
            if !fileManager.fileExists(atPath: documentsURL.path) {
                try fileManager.createDirectory(at: documentsURL, withIntermediateDirectories: true)
            }
            let contents = try fileManager.contentsOfDirectory(atPath: documentsURL.path)
            files = contents.filter { $0.hasSuffix(".txt") }.sorted(by: >)
        } catch {
            print("Error loading files: \(error)")
        }
    }
    
    func saveDraft(text: String, fileName: String) {
        let safeFileName = fileName.hasSuffix(".txt") ? fileName : fileName + ".txt"
        currentFileName = safeFileName
        fileContent = text
        saveFile()
    }
    
    func saveFile() {
        guard !currentFileName.isEmpty else { return }
        let fileURL = documentsURL.appendingPathComponent(currentFileName)
        do {
            try fileContent.write(to: fileURL, atomically: true, encoding: .utf8)
            loadFiles()
        } catch {
            print("Failed to save file: \(error)")
        }
    }
    
    func deleteFile(named name: String) {
        let fileURL = documentsURL.appendingPathComponent(name)
        do {
            try fileManager.removeItem(at: fileURL)
            loadFiles()
        } catch {
            print("Failed to delete file: \(error)")
        }
    }
    
    func createNewDraft() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let timestamp = formatter.string(from: Date())
        let newFileName = "Draft_\(timestamp).txt"

        currentFileName = newFileName
        fileContent = ""  // fresh content
    }

}
