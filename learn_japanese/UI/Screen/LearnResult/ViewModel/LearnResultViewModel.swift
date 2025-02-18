//
//  LearnResultViewModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 18/2/25.
//

import Foundation

import Foundation

class LearnResultViewModel {
    var correctAnswer: Int = 0
    var wrongAnswer: Int = 0
    
    init(correctAnswer: Int, wrongAnswer: Int) {
        self.correctAnswer = correctAnswer
        self.wrongAnswer = wrongAnswer
    }
}

