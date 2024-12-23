//
//  LessonDTO.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 22/12/24.
//

import Foundation

struct LessonDTO {
    var lesssonModel: LessonModel
    var totalExercises: Int
    var completedExercises: Int
    var isAccessible: Bool
    
    init(lesssonModel: LessonModel, totalExercises: Int, completedExercises: Int, isAccessible: Bool) {
        self.lesssonModel = lesssonModel
        self.totalExercises = totalExercises
        self.completedExercises = completedExercises
        self.isAccessible = isAccessible
    }
}
