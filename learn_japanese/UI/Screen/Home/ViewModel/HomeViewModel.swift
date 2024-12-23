//
//  HomeViewModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 3/8/24.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    
}

class HomeViewModel {
    var delegate: HomeViewModelDelegate?
    var japaneseLevel: JapaneseLevel = .basic
    var lessonDTOs: [LessonDTO] = []
    
    init(japaneseLevel: JapaneseLevel) {
        self.japaneseLevel = japaneseLevel
    }
    
    func fetchLesssons() {
        let lessons = LessonServiceUtils.getLesson(byLevel: japaneseLevel.level.rawValue)
        lessonDTOs = lessons.map({ lessonModel in
            let activities = ActivityServiceUtils.getActivity(byLessonId: lessonModel.lessonId)
            var excercises = []
            
            activities.forEach { activity in
                excercises.append(contentsOf: ExerciseServiceUtils.getExercise(byActivityId: activity.activityId))
            }
            
            let lessonProgressModel = UserProgressManager.shared.userProgressModel?.lessons.first(where: { lessonProgressModel in
                lessonProgressModel.lessonId == lessonModel.lessonId
            })
                        
            return LessonDTO(lesssonModel: lessonModel, totalExercises: excercises.count, completedExercises: lessonProgressModel?.completedExercises ?? 0, isAccessible: lessonProgressModel?.isAccessible ?? false)
        })
    }
}
