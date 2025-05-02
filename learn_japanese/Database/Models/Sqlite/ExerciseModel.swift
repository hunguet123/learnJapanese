//
//  ExerciseModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 17/12/24.
//

struct ExerciseModel {
    let exerciseId: Int
    let exerciseNumber: Double
    let lessonId: Int
    var title: String?
    let description: String?
    
    init(exerciseId: Int,
         exerciseNumber: Double,
         lessonId: Int,
         title: String?,
         description: String?) {
        self.exerciseId = exerciseId
        self.exerciseNumber = exerciseNumber
        self.lessonId = lessonId
        self.title = title
        self.description = description
    }
}
