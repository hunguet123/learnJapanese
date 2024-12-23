//
//  LessonProgressModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 22/12/24.
//

struct LessonProgressModel: Codable {
    var lessonId: Int
    var totalExercises: Int
    var completedExercises: Int
    var isAccessible: Bool
    var exercises: [ExerciseProgressModel]

    init(
        lessonId: Int,
        totalExercises: Int,
        completedExercises: Int = 0,
        isAccessible: Bool = false,
        exercises: [ExerciseProgressModel] = []
    ) {
        self.lessonId = lessonId
        self.totalExercises = totalExercises
        self.completedExercises = completedExercises
        self.isAccessible = isAccessible
        self.exercises = exercises
    }
}

extension LessonProgressModel {
    func toJson() -> [String: Any] {
        let exerciseObjects = exercises.map { $0.toJson() }
        return [
            "lessonId": lessonId,
            "totalExercises": totalExercises,
            "completedExercises": completedExercises,
            "isAccessible": isAccessible,
            "exercises": exerciseObjects
        ]
    }

    static func fromJson(_ json: [String: Any]) -> LessonProgressModel? {
        guard let lessonId = json["lessonId"] as? Int,
              let totalExercises = json["totalExercises"] as? Int,
              let completedExercises = json["completedExercises"] as? Int,
              let isAccessible = json["isAccessible"] as? Bool,
              let exercisesJson = json["exercises"] as? [[String: Any]] else { return nil }
        
        let exercises = exercisesJson.compactMap { ExerciseProgressModel.fromJson($0) }
        return LessonProgressModel(
            lessonId: lessonId,
            totalExercises: totalExercises,
            completedExercises: completedExercises,
            isAccessible: isAccessible,
            exercises: exercises
        )
    }
}
