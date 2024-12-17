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
    var lessons: [LessonModel] = []
    
    init(japaneseLevel: JapaneseLevel) {
        self.japaneseLevel = japaneseLevel
    }
    
    func fetchLesssons() {
        lessons = LessonServiceUtils.fetchAllLessons()
    }
}
