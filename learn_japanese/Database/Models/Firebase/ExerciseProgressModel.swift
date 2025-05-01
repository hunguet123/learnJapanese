//
//  ExerciseProgressModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 22/12/24.
//

struct ExerciseProgressModel: Codable {
    var exerciseId: Int
    var attempts: Int
    var wrongQuestions: [QuestionProgressModel] = []
    var learnedQuestions: [QuestionProgressModel] = []
    var score: ScoreModel
    
    init(exerciseId: Int, attempts: Int = 0, score: ScoreModel, wrongQuestions: [QuestionProgressModel] = [], learnedQuestions: [QuestionProgressModel] = []) {
        self.exerciseId = exerciseId
        self.attempts = attempts
        self.score = score
        self.wrongQuestions = wrongQuestions
        self.learnedQuestions = learnedQuestions
    }
}

extension ExerciseProgressModel {
    func toJson() -> [String: Any] {
        return [
            "exerciseId": exerciseId,
            "attempts": attempts,
            "wrongQuestions": wrongQuestions.map { $0.toJson() },
            "learnedQuestions": learnedQuestions.map { $0.toJson() },
            "score": score.toJson()
        ]
    }
    
    static func fromJson(_ json: [String: Any]) -> ExerciseProgressModel? {
        guard let exerciseId = json["exerciseId"] as? Int,
              let attempts = json["attempts"] as? Int,
              let scoreJson = json["score"] as? [String: Any],
              let wrongQuestionsJson = json["wrongQuestions"] as? [[String: Any]],
              let score = ScoreModel.fromJson(scoreJson) else { return nil }
        let wrongQuestions = wrongQuestionsJson.compactMap { QuestionProgressModel.fromJson($0) }
        if let learnedQuestionsJson = json["learnedQuestions"] as? [[String: Any]] {
            let learnedQuestions = learnedQuestionsJson.compactMap {
                QuestionProgressModel.fromJson($0)
            }
            return ExerciseProgressModel(
                exerciseId: exerciseId,
                attempts: attempts,
                score: score,
                wrongQuestions: wrongQuestions,
                learnedQuestions: learnedQuestions
            )
        }
        
        return ExerciseProgressModel(
            exerciseId: exerciseId,
            attempts: attempts,
            score: score,
            wrongQuestions: wrongQuestions
        )
    }
}
