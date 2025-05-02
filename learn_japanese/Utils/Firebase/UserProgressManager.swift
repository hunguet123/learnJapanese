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
    
    func isEqual(to other: FirebaseResult) -> Bool {
        switch (self, other) {
        case (.success, .success):
            return true
        case (.failure(let error1), .failure(let error2)):
            return (error1 as NSError).domain == (error2 as NSError).domain &&
            error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
}

class UserProgressManager {
    private let db = Firestore.firestore()
    private let collectionName = "userProgress"
    var userProgressModel: UserProgressModel?
    
    static let shared = UserProgressManager()
    
    func addLessonProgress(
        lessonId: Int,
        totalExercises: Int,
        isAccessible: Bool,
        completion: @escaping (FirebaseResult) -> Void
    ) {
        guard let userModel = UserManager.shared.getUser() else {
            return
        }
        let userId = userModel.id
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
                    self.fetchUserProgress() { result in
                        print("userProgress save: \(result)")
                        completion(.success)
                    }
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
                        self.fetchUserProgress() { result in
                            print("userProgress save: \(result)")
                            completion(.success)
                        }
                    }
                }
            }
        }
    }
    
    func updateExerciseProgress(
        lessonId: Int,
        exerciseId: Int,
        score: Int,
        maxScore: Int,
        wrongQuestionIds: [Int],
        learnedQuestionIds: [Int],
        completed: Bool,
        completion: @escaping (FirebaseResult) -> Void
    ) {
        guard let userModel = UserManager.shared.getUser() else {
            return
        }
        let userId = userModel.id
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
                
                // Cập nhật wrongQuestions
                var updatedWrongQuestions: [QuestionProgressModel] = []
                
                // Xử lý các câu hỏi cũ
                for var wrongQuestion in exercise.wrongQuestions {
                    if wrongQuestionIds.contains(wrongQuestion.questionId) {
                        // Nếu vẫn còn trong danh sách mới, tăng studyCount và cập nhật updatedAt
                        wrongQuestion.questionStudyCount += 1
                        updatedWrongQuestions.append(wrongQuestion)
                    } else {
                        // Nếu không còn trong danh sách mới, giảm studyCount 1
                        wrongQuestion.questionStudyCount -= 1
                        wrongQuestion.updatedAt = Date()
                        if wrongQuestion.questionStudyCount > 0 {
                            // Nếu còn studyCount thì giữ lại
                            updatedWrongQuestions.append(wrongQuestion)
                        }
                        // Nếu studyCount == 0 thì bỏ luôn (xóa)
                    }
                }
                
                // Thêm các wrongQuestion mới nếu chưa có trong danh sách cũ
                for questionId in wrongQuestionIds {
                    if !updatedWrongQuestions.contains(where: { $0.questionId == questionId }) {
                        updatedWrongQuestions.append(QuestionProgressModel(questionId: questionId, questionStudyCount: 1, updatedAt: Date()))
                    }
                }
                exercise.wrongQuestions = updatedWrongQuestions
                
                // Cập nhật learnedQuestions với updatedAt và tăng questionStudyCount tương tự
                var updatedLearnedQuestions = exercise.learnedQuestions.map { learnedQuestion -> QuestionProgressModel in
                    var updatedQuestion = learnedQuestion
                    if learnedQuestionIds.contains(updatedQuestion.questionId) {
                        updatedQuestion.questionStudyCount += 1
                        updatedQuestion.updatedAt = Date()
                    }
                    return updatedQuestion
                }
                
                // Thêm các learnedQuestion mới nếu chưa có
                for questionId in learnedQuestionIds {
                    if !updatedLearnedQuestions.contains(where: { $0.questionId == questionId }) {
                        updatedLearnedQuestions.append(QuestionProgressModel(questionId: questionId, questionStudyCount: 1, updatedAt: Date()))
                    }
                }
                exercise.learnedQuestions = updatedLearnedQuestions
                
                lesson.exercises[exerciseIndex] = exercise
            } else {
                // Add new exercise
                let newExercise = ExerciseProgressModel(
                    exerciseId: exerciseId,
                    attempts: 1,
                    score: ScoreModel(value: score, max: maxScore),
                    wrongQuestions: wrongQuestionIds.map({ questionId in
                        return QuestionProgressModel(questionId: questionId, questionStudyCount: 1, updatedAt: Date())
                    }),
                    learnedQuestions: learnedQuestionIds.map({ questionId in
                        return QuestionProgressModel(questionId: questionId, questionStudyCount: 1, updatedAt: Date())
                    })
                )
                lesson.exercises.append(newExercise)
            }
            
            if completed {
                lesson.completedExercises = lesson.exercises.count
            }
            
            userProgress.lessons[lessonIndex] = lesson
            
            let updatedData = userProgress.toJson()
            documentRef.setData(updatedData, merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    self.fetchUserProgress() { result in
                        print("userProgress save: \(result)")
                        completion(.success)
                    }
                }
            }
        }
    }
    
    func fetchUserProgress(
        completion: @escaping (FirebaseResult) -> Void
    ) {
        guard let userModel = UserManager.shared.getUser() else {
            //            UserManager.shared.signOut()
            return
        }
        let userId = userModel.id
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
    
    func getExercisesToReview(daysThreshold: Int = 1) -> [(lessonId: Int, exerciseId: Int, accuracy: Double)] {
        guard let userProgress = userProgressModel else {
            return []
        }
        
        let now = Date()
        let calendar = Calendar.current
        var exercisesToReview: [(lessonId: Int, exerciseId: Int, accuracy: Double)] = []
        
        for lesson in userProgress.lessons {
            for exercise in lesson.exercises {
                
                // Kiểm tra trong wrongQuestions có câu hỏi cần ôn tập không
                let wrongNeedsReview = exercise.wrongQuestions.contains { questionProgress in
                    if let updatedAt = questionProgress.updatedAt {
                        if let diff = calendar.dateComponents([.day], from: updatedAt, to: now).day {
                            return diff >= daysThreshold
                        }
                    }
                    return false
                }
                
                // Nếu không có câu hỏi trong wrongQuestions cần ôn tập thì kiểm tra learnedQuestions
                let learnedNeedsReview = !wrongNeedsReview && exercise.learnedQuestions.contains { questionProgress in
                    if let updatedAt = questionProgress.updatedAt {
                        if let diff = calendar.dateComponents([.day], from: updatedAt, to: now).day {
                            return diff >= daysThreshold
                        }
                    }
                    return false
                }
                
                if wrongNeedsReview || learnedNeedsReview {
                    exercisesToReview.append((
                        lessonId: lesson.lessonId,
                        exerciseId: exercise.exerciseId,
                        accuracy: Double(exercise.score.value) / Double(exercise.score.max)
                    ))
                }
            }
        }
        
        return exercisesToReview
    }

    func getQuestionsToReviewCombined(
        lessonId: Int,
        exerciseId: Int,
        daysThreshold: Int = 1
    ) -> [QuestionProgressModel] {
        guard let userProgress = userProgressModel else {
            return []
        }
        
        let now = Date()
        let calendar = Calendar.current
        
        guard let lesson = userProgress.lessons.first(where: { $0.lessonId == lessonId }),
              let exercise = lesson.exercises.first(where: { $0.exerciseId == exerciseId }) else {
            return []
        }
        
        // Lọc câu hỏi trong wrongQuestions thoả điều kiện ôn tập
        let wrongQuestionsToReview = exercise.wrongQuestions.filter { questionProgress in
            if let updatedAt = questionProgress.updatedAt,
               let diff = calendar.dateComponents([.day], from: updatedAt, to: now).day {
                return diff >= daysThreshold
            }
            return false
        }
        
        // Tạo set questionId của wrongQuestions để tránh trùng lặp
        let wrongQuestionIds = Set(wrongQuestionsToReview.map { $0.questionId })
        
        // Lọc câu hỏi trong learnedQuestions thoả điều kiện ôn tập và không trùng với wrongQuestions
        let learnedQuestionsToReview = exercise.learnedQuestions.filter { questionProgress in
            if wrongQuestionIds.contains(questionProgress.questionId) {
                return false
            }
            if let updatedAt = questionProgress.updatedAt,
               let diff = calendar.dateComponents([.day], from: updatedAt, to: now).day {
                return diff >= daysThreshold
            }
            return false
        }
        
        // Kết hợp 2 tập câu hỏi
        let combinedQuestions = wrongQuestionsToReview + learnedQuestionsToReview
        
        return combinedQuestions
    }
}
