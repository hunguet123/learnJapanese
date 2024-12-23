//
//  ExerciseProgressModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 22/12/24.
//

struct ExerciseProgressModel: Codable {
    var exerciseId: Int
    var attempts: Int
    var score: ScoreModel

    init(exerciseId: Int, attempts: Int = 0, score: ScoreModel) {
        self.exerciseId = exerciseId
        self.attempts = attempts
        self.score = score
    }
}

extension ExerciseProgressModel {
    func toJson() -> [String: Any] {
        return [
            "exerciseId": exerciseId,
            "attempts": attempts,
            "score": score.toJson()
        ]
    }

    static func fromJson(_ json: [String: Any]) -> ExerciseProgressModel? {
        guard let exerciseId = json["exerciseId"] as? Int,
              let attempts = json["attempts"] as? Int,
              let scoreJson = json["score"] as? [String: Any],
              let score = ScoreModel.fromJson(scoreJson) else { return nil }
        
        return ExerciseProgressModel(
            exerciseId: exerciseId,
            attempts: attempts,
            score: score
        )
    }
}
