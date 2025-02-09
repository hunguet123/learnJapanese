//
//  LearnSectionViewModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 8/8/24.
//

import Foundation

class LearnSectionViewModel {
    var wrongQuestionIds: [Int] = []
    var questions: [QuestionModel] = []
    var score: Int = 0
    func fetchAllQuestions(byExcerciseId excerciseId: Int){
        questions = QuestionServiceUtils.fetchAllQuestions(byExcerciseId: excerciseId)
        
    }
}
