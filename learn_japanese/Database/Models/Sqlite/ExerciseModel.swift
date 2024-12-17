//
//  ExerciseModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 17/12/24.
//

struct ExerciseModel {
    let exerciseId: Int
    let exerciseNumber: String
    let activityId: Int
    let title: String?
    let description: String?
    
    init(exerciseId: Int, exerciseNumber: String, activityId: Int, title: String?, description: String?) {
        self.exerciseId = exerciseId
        self.exerciseNumber = exerciseNumber
        self.activityId = activityId
        self.title = title
        self.description = description
    }
}
