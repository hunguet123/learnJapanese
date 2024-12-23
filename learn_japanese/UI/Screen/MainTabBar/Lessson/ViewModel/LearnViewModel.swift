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
        let activities = ActivityServiceUtils.getActivity(byLessonId: lessonId)
        var excercises: [ExerciseModel] = []
        
        activities.forEach { activity in
            excercises.append(contentsOf: ExerciseServiceUtils.getExercise(byActivityId: activity.activityId))
        }
        
        exerciseDTOs = excercises.enumerated().map { (index, exerciseModel) in
            return ExerciseDTO(exerciseModel: exerciseModel, state: index == 0 ? .canLearn : .cantLearn)
        }
    }
}
