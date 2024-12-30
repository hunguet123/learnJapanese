//
//  LearnSectionViewModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 8/8/24.
//

import Foundation

class LearnSectionViewModel {
    func fetchAllQuestions(byExcerciseId excerciseId: Int){
        let questions = QuestionServiceUtils.fetchAllQuestions(byExcerciseId: excerciseId)
        
    }
}
