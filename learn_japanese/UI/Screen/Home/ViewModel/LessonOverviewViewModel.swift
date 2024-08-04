//
//  LessonOverviewViewModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 4/8/24.
//

import Foundation

protocol LessonOverviewViewModelDelegate: AnyObject {
    
}

class LessonOverviewViewModel {
    var delegate: LessonOverviewViewModelDelegate?
    var totalNumberOfLessons: Int = 0
    var numberOfLesssonsLearned: Int = 0
    var name: String = ""
    var isCanLearn: Bool = false
    
    init(totalNumberOfLessons: Int, numberOfLesssonsLearned: Int, isCanLearn: Bool?, name: String) {
        self.totalNumberOfLessons = totalNumberOfLessons
        self.numberOfLesssonsLearned = numberOfLesssonsLearned
        self.isCanLearn = isCanLearn ?? false
        self.name = name
    }
}
