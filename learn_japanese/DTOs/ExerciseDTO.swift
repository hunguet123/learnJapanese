//
//  ExerciseDTO.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 23/12/24.
//

import Foundation

enum ExerciseState {
    case learned
    case canLearn
    case cantLearn
}

struct ExerciseDTO {
    var exerciseModel: ExerciseModel
    var state: ExerciseState
    
    init(exerciseModel: ExerciseModel, state: ExerciseState) {
        self.exerciseModel = exerciseModel
        self.state = state
    }
}
