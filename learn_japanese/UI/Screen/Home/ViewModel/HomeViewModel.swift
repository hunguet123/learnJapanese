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
    var lessons: [UnitOverviewModel] = []
    
    init(japaneseLevel: JapaneseLevel) {
        self.japaneseLevel = japaneseLevel
    }
    
    func fetchLesssons() {
        // TODO: fakedata
        lessons = [
            UnitOverviewModel(id: "1", totalNumberOfLessons: 8, numberOfLesssonsLearned: 8, name: "Hiragana", isLearned: true, sectionIds: ["1","2","3"]),
            UnitOverviewModel(id: "2", totalNumberOfLessons: 8, numberOfLesssonsLearned: 4, name: "Katakana", isLearned: true,  sectionIds: ["1","2","3"]),
            UnitOverviewModel(id: "3", totalNumberOfLessons: 8, numberOfLesssonsLearned: 4, name: "Pronuciation", isLearned: true,  sectionIds: ["1","2","3"]),
            UnitOverviewModel(id: "4", totalNumberOfLessons: 8, numberOfLesssonsLearned: 4, name: "Katakana", isLearned: true,  sectionIds: ["1","2","3"]),
            UnitOverviewModel(id: "5", totalNumberOfLessons: 8, numberOfLesssonsLearned: 4, name: "Pronuciation", isLearned: false,  sectionIds: ["1","2","3"]),
            UnitOverviewModel(id: "6", totalNumberOfLessons: 8, numberOfLesssonsLearned: 4, name: "Katakana", isLearned: false,  sectionIds: ["1","2","3"]),
            UnitOverviewModel(id: "7", totalNumberOfLessons: 8, numberOfLesssonsLearned: 4, name: "Pronuciation", isLearned: false,  sectionIds: ["1","2","3"]),
        ]
    }
}
