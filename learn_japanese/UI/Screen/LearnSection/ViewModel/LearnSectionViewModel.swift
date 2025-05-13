//
//  LearnSectionViewModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 8/8/24.
//

import Foundation

class LearnSectionViewModel {
    var wrongQuestionIds: [Int] = []
    var correctQuestionIds: [Int] = []
    var questions: [QuestionModel] = []
    var score: Int = 0
    func fetchAllQuestions(byExcerciseId excerciseId: Int){
        resetAll()
        questions = QuestionServiceUtils.fetchAllQuestions(byExcerciseId: excerciseId)
    }
    
    func fetchAllReviewQuesions(questionProgressModels: [QuestionProgressModel]){
        resetAll()
        questions = QuestionServiceUtils.fetchAllQuestions(questionProgressModels.map{ $0.questionId })
    }
    
    func resetAll(){
        wrongQuestionIds.removeAll()
        correctQuestionIds.removeAll()
        questions.removeAll()
        score = 0
    }
}
