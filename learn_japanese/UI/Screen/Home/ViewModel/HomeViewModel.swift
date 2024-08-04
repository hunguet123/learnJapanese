//
//  HomeViewModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 3/8/24.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    
}

class HomeViewModel {
    var delegate: HomeViewModelDelegate?
    var japaneseLevel: JapaneseLevel = .basic
    var lessons: [LessonOverviewViewModel] = []
    
    init(japaneseLevel: JapaneseLevel) {
        self.japaneseLevel = japaneseLevel
    }
    
    func fetchLesssons() {
        // TODO: fakedata
        lessons = [
            LessonOverviewViewModel(totalNumberOfLessons: 8, numberOfLesssonsLearned: 4, isCanLearn: true, name: "Hiragana"),
            LessonOverviewViewModel(totalNumberOfLessons: 8, numberOfLesssonsLearned: 4, isCanLearn: false, name: "Katakana"),
            LessonOverviewViewModel(totalNumberOfLessons: 8, numberOfLesssonsLearned: 4, isCanLearn: false, name: "Pronuciation"),
            LessonOverviewViewModel(totalNumberOfLessons: 8, numberOfLesssonsLearned: 4, isCanLearn: false, name: "Katakana"),
            LessonOverviewViewModel(totalNumberOfLessons: 8, numberOfLesssonsLearned: 4, isCanLearn: false, name: "Pronuciation"),
            LessonOverviewViewModel(totalNumberOfLessons: 8, numberOfLesssonsLearned: 4, isCanLearn: false, name: "Katakana"),
            LessonOverviewViewModel(totalNumberOfLessons: 8, numberOfLesssonsLearned: 4, isCanLearn: false, name: "Pronuciation"),
        ]
    }
}
