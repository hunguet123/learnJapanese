//
//  UserProgressManager.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 16/12/24.
//

import Foundation
import FirebaseFirestore

enum FirebaseResult {
    case success
    case failure(Error)
}

class UserProgressManager {
    private let db = Firestore.firestore()
    private let collectionName = "userProgress"
    var userProgressModel: UserProgressModel?

    static let shared = UserProgressManager()

    func addLessonProgress(
        userId: String,
        lessonId: Int,
        totalExercises: Int,
        isAccessible: Bool,
        completion: @escaping (FirebaseResult) -> Void
    ) {
        let documentRef = Firestore.firestore().collection("userProgress").document(userId)
        
        documentRef.getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                let newProgress = UserProgressModel(
                    lessons: [
                        LessonProgressModel(
                            lessonId: lessonId,
                            totalExercises: totalExercises,
                            completedExercises: 0,
                            isAccessible: isAccessible
                        )
                    ]
                )
                
                let data = newProgress.toJson()
                documentRef.setData(data) { [weak self] error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        self?.userProgressModel = newProgress
                        completion(.success)
                    }
                }
                return
            }
            
            // Document exists, check if the lesson already exists
            if let progressData = document.data(),
               let existingProgress = UserProgressModel.fromJson(progressData) {
                if existingProgress.lessons.contains(where: { $0.lessonId == lessonId }) {
                    print("Lesson \(lessonId) already exists.")
                    self.fetchUserProgress(userId: userId) { result in
                        print("userProgress save: \(result)")
                        completion(.success)                    }
                    return
                }
                
                var updatedProgress = existingProgress
                updatedProgress.lessons.append(
                    LessonProgressModel(
                        lessonId: lessonId,
                        totalExercises: totalExercises,
                        completedExercises: 0,
                        isAccessible: isAccessible
                    )
                )
                
                let data = updatedProgress.toJson()
                documentRef.setData(data, merge: true) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success)
                    }
                }
            }
        }
    }
    
    func updateExerciseProgress(
        userId: String,
        lessonId: Int,
        exerciseId: Int,
        score: Int,
        maxScore: Int,
        completed: Bool,
        completion: @escaping (FirebaseResult) -> Void
    ) {
        let documentRef = Firestore.firestore().collection("userProgress").document(userId)
        
        documentRef.getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = documentSnapshot, document.exists,
                  let data = document.data(),
                  var userProgress = UserProgressModel.fromJson(data) else {
                completion(.failure(NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "User progress not found."])))
                return
            }
            
            guard let lessonIndex = userProgress.lessons.firstIndex(where: { $0.lessonId == lessonId }) else {
                completion(.failure(NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Lesson \(lessonId) not found."])))
                return
            }
            
            var lesson = userProgress.lessons[lessonIndex]
            
            if let exerciseIndex = lesson.exercises.firstIndex(where: { $0.exerciseId == exerciseId }) {
                // Update existing exercise
                var exercise = lesson.exercises[exerciseIndex]
                exercise.attempts += 1
                exercise.score.value = score
                exercise.score.max = maxScore
                lesson.exercises[exerciseIndex] = exercise
            } else {
                // Add new exercise
                let newExercise = ExerciseProgressModel(
                    exerciseId: exerciseId,
                    attempts: 1,
                    score: ScoreModel(value: score, max: maxScore)
                )
                lesson.exercises.append(newExercise)
            }
            
            if completed {
                lesson.completedExercises += 1
            }
            
            userProgress.lessons[lessonIndex] = lesson
            
            let updatedData = userProgress.toJson()
            documentRef.setData(updatedData, merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success)
                }
            }
        }
    }
    
    private func fetchUserProgress(
        userId: String,
        completion: @escaping (FirebaseResult) -> Void
    ) {
        let documentRef = Firestore.firestore().collection("userProgress").document(userId)
        
        documentRef.getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = documentSnapshot, document.exists,
                  let data = document.data() else {
                let error = NSError(
                    domain: "Firestore",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "User progress not found."]
                )
                completion(.failure(error))
                return
            }
            
            if let userProgress = UserProgressModel.fromJson(data) {
                // Gán giá trị vào `userProgressModel` nếu cần thiết
                self.userProgressModel = userProgress
                completion(.success)
            } else {
                let error = NSError(
                    domain: "Parsing",
                    code: 500,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to parse user progress data."]
                )
                completion(.failure(error))
            }
        }
    }
}
