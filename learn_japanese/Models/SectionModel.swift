//
//  LessonDetailsModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 6/8/24.
//

import Foundation

class SectionModel {
    var name: String?
    var isLearned: Bool?
    
    init(name: String? = nil, isLearned: Bool? = nil) {
        self.name = name
        self.isLearned = isLearned
    }
}
