//
//  ViewModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 5/8/24.
//

import Foundation

class LearnViewModel {
    var exerciseDTOs: [ExerciseDTO] = []
    
    func fetchExercises(byLessonId lessonId: Int) {
        let excercises: [ExerciseModel] = ExerciseServiceUtils.getExercises(byLessonId: lessonId)
        
        let lessonProgressModel = UserProgressManager.shared.userProgressModel?.lessons.first(where: { lessonProgressModel in
            return lessonProgressModel.lessonId == lessonId
        })
        
        var learnedExercisesCount: Int = 0
        self.exerciseDTOs = excercises.enumerated().map { (index, exerciseModel) in
            if lessonProgressModel?.exercises.contains(where: { exerciseProgressModel in
                return exerciseProgressModel.exerciseId == exerciseModel.exerciseId
            }) == true {
                learnedExercisesCount += 1
                return ExerciseDTO(exerciseModel: exerciseModel, state: .learned)
            }
            
            if index == 0 || index == learnedExercisesCount {
                return ExerciseDTO(exerciseModel: exerciseModel, state: .canLearn)
            }

            return ExerciseDTO(exerciseModel: exerciseModel, state: .cantLearn)
        }
    }
}
