//
//  LessonModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 6/8/24.
//

import Foundation

class UnitOverviewModel {
    var id: String?
    var totalNumberOfLessons: Int?
    var numberOfLesssonsLearned: Int?
    var name: String?
    var isLearned: Bool?
    var sectionIds: [String]?
    
    init(id: String? = nil,
         totalNumberOfLessons: Int? = nil,
         numberOfLesssonsLearned: Int? = nil,
         name: String? = nil,
         isLearned: Bool? = nil,
         sectionIds: [String]?) {
        self.id = id
        self.totalNumberOfLessons = totalNumberOfLessons
        self.numberOfLesssonsLearned = numberOfLesssonsLearned
        self.name = name
        self.isLearned = isLearned
        self.sectionIds = sectionIds
    }
}
