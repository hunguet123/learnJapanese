//
//  ReviewViewModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 2/5/25.
//

import Foundation

class ReviewViewModel {
    var exerciseDTOs: [ExerciseDTO] = []
    
    func getReviewData() {
        exerciseDTOs = []
        let reviewList = UserProgressManager.shared.getExercisesToReview()
        reviewList.forEach { (lessonId, exerciseId, accuracy) in
            let lessonTitle = LessonServiceUtils.getLesson(byLessonId: lessonId)?.title ?? ""
            if var exercise = ExerciseServiceUtils.getExercise(byExerciseId: exerciseId) {
                let exerciseTitle = exercise.title ?? ""
                exercise.title = "\(lessonTitle) - \(exerciseTitle)"
                exerciseDTOs.append(ExerciseDTO(exerciseModel: exercise, state: .canLearn, accuracy: accuracy))
            }
        }
    }
}
