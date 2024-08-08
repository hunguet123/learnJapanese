//
//  ViewModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 5/8/24.
//

import Foundation

class LearnViewModel {
    var sections: [SectionModel]?
    
    func fetchData(lessonId: String) {
        // TODO: fake fetch data from lessonId
        self.sections = [
            SectionModel(id: "1", name: "Hiragana", isLearned: true),
            SectionModel(id: "1", name: "Hiragana", isLearned: true),
            SectionModel(id: "1", name: "Hiragana", isLearned: false),
            SectionModel(id: "1", name: "Hiragana", isLearned: false),
            SectionModel(id: "1", name: "Hiragana", isLearned: false),
            SectionModel(id: "1", name: "Hiragana", isLearned: false),
            SectionModel(id: "1", name: "Hiragana", isLearned: false),
            SectionModel(id: "1", name: "Hiragana", isLearned: false),
            SectionModel(id: "1", name: "Hiragana", isLearned: false),
        ]
    }
}
