//
//  HandwritingViewModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 3/4/25.
//

import Foundation

struct WritingModel: Equatable {
    var character: String = ""
    var score: Double = 0.0
    
    init(character: String, score: Double) {
        self.character = character
        self.score = score
    }
    
    init() {
        
    }
}

class HandwritingViewModel {
    
    var resultUpdated: (() -> Void)?
    
    private var writingModels = [WritingModel]() {
        didSet {
            resultUpdated?()
        }
    }
    
    var results: [WritingModel] {
        return writingModels
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
        writingModels = [WritingModel]()
        recognizer?.clear()
    }
    
    func resultCount() -> Int {
        return writingModels.count
    }
    
    func result(atIndex: Int) -> WritingModel {
        if (atIndex >= writingModels.count) {
            return WritingModel()
        }
        return writingModels[atIndex]
    }
    
    private func recognize() {
        var results: [Result]?
        for index in (processedStrokeCount..<allStrokes.count) {
            results = recognizer?.classify(allStrokes[index])
            processedStrokeCount += 1
        }

        if results != nil {
            writingModels = results!.map { WritingModel(character: $0.value, score: Double(truncating: $0.score)) }
        }
    }
}
