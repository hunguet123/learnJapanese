//
//  LessonDetailsModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 6/8/24.
//

import Foundation

enum SectionState {
    case learned
    case canLearn
    case cantLearn
}

class SectionModel {
    var id: String?
    var name: String?
    var sectionSate: SectionState?
    
    init(id: String, name: String? = nil, sectionSate: SectionState? = nil) {
        self.id = id
        self.name = name
        self.sectionSate = sectionSate
    }
}
