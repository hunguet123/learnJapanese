//
//  QuestionProgressModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 9/2/25.
//

struct QuestionProgressModel: Codable {
    var questionId: Int
    var questionStudyCount: Int
    
    init(questionId: Int, questionStudyCount: Int) {
        self.questionId = questionId
        self.questionStudyCount = questionStudyCount
    }
}

extension QuestionProgressModel {
    func toJson() -> [String: Any] {
        return [
            "questionId": questionId,
            "questionStudyCount": questionStudyCount
        ]
    }
    
    static func fromJson(_ json: [String: Any]) -> QuestionProgressModel? {
        guard let questionId = json["questionId"] as? Int,
              let questionStudyCount = json["questionStudyCount"] as? Int else { return nil }
        return QuestionProgressModel(questionId: questionId, questionStudyCount: questionStudyCount)
    }
}
