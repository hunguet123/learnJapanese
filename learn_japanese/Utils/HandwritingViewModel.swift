//
//  HandwritingViewModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 3/4/25.
//

import Foundation

class HandwritingViewModel {
    
    var resultUpdated: (() -> Void)?
    
    private var characters = [String]() {
        didSet {
            resultUpdated?()
        }
    }
    
    var results: [String] {
        return characters
    }
    
    private var allStrokes = [[NSValue]]()
    private var processedStrokeCount = 0
    private var recognizer: Recognizer?

    init(canvas: UIView) {
        recognizer = Recognizer(canvas: canvas)
    }

    func add(_ stroke: [NSValue]) {
        allStrokes.append(stroke)
        recognize()
    }
    
    func add(_ strokes: [[NSValue]]) {
        allStrokes.append(contentsOf: strokes)
        recognize()
    }
    
    func clear() {
        allStrokes.removeAll()
        processedStrokeCount = 0
        characters = [String]()
        recognizer?.clear()
    }
    
    func resultCount() -> Int {
        return characters.count
    }
    
    func result(atIndex: Int) -> String {
        if (atIndex >= characters.count) {
            return ""
        }
        return characters[atIndex]
    }
    
    private func recognize() {
        var results: [Result]?
        for index in (processedStrokeCount..<allStrokes.count) {
            results = recognizer?.classify(allStrokes[index])
            processedStrokeCount += 1
        }

        if results != nil {
            characters = results!.map { $0.value }
        }
    }
}
