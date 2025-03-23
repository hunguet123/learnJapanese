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
    var onChangeApiStatus: ((ApiStatus) -> Void)?
    
    init(japaneseLevel: JapaneseLevel) {
        self.japaneseLevel = japaneseLevel
    }
    
    func fetchLesssons() {
        self.onChangeApiStatus?(ApiStatus.loading)
        UserProgressManager.shared.fetchUserProgress { [weak self] result in
            if (result.isEqual(to: .success)) {
                let lessons = LessonServiceUtils.getLesson(byLevel: self?.japaneseLevel.level.rawValue ?? "")
                self?.lessonDTOs = lessons.map({ lessonModel in
                    var excercises = ExerciseServiceUtils.getExercise(byLessonId: lessonModel.lessonId)
                    
                    let lessonProgressModel = UserProgressManager.shared.userProgressModel?.lessons.first(where: { lessonProgressModel in
                        lessonProgressModel.lessonId == lessonModel.lessonId
                    })
                                
                    return LessonDTO(lesssonModel: lessonModel, totalExercises: excercises.count, completedExercises: lessonProgressModel?.completedExercises ?? 0, isAccessible: lessonProgressModel?.isAccessible ?? false)
                })
                self?.onChangeApiStatus?(ApiStatus.success)
                self?.checkForUpdates(lessons: lessons)
            } else {
                self?.onChangeApiStatus?(ApiStatus.failure)
            }
            print("fetch userProgress: \(result)")
        }
    }
    
    private func checkForUpdates(lessons: [LessonModel]) {
        let lastLessonProgressModel = UserProgressManager.shared.userProgressModel?.lessons.last
        let lastLessonProgressModelIndex = lessons.firstIndex(where: { lessonModel in
            return lessonModel.lessonId == lastLessonProgressModel?.lessonId
        }) ?? 0
        if (lastLessonProgressModelIndex == lessons.count - 1) {
            return
        }
        
        let lastLesson = lessons[lastLessonProgressModelIndex + 1]
        
        if (lastLessonProgressModel?.completedExercises == lastLessonProgressModel?.totalExercises && UserProgressManager.shared.userProgressModel?.lessons.count ?? 0 < lessons.count) {
            let excercises: [ExerciseModel] = ExerciseServiceUtils.getExercise(byLessonId: lastLesson.lessonId)
            
            UserProgressManager.shared.addLessonProgress(lessonId: lastLesson.lessonId, totalExercises: excercises.count, isAccessible: true) { firebaseResult in
                if (firebaseResult.isEqual(to: .success)) {
                    self.fetchLesssons()
                    self.onChangeApiStatus?(ApiStatus.success)
                } else {
                    self.onChangeApiStatus?(ApiStatus.failure)
                }
                print("---- add lessonProgress: \(firebaseResult)")
            }
        }

    }
}
