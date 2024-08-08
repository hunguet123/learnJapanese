//
//  LessonDetailsModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 6/8/24.
//

import Foundation

class SectionModel {
    var id: String?
    var name: String?
    var isLearned: Bool?
    
    init(id: String, name: String? = nil, isLearned: Bool? = nil) {
        self.id = id
        self.name = name
        self.isLearned = isLearned
    }
}
