//
//  QuestionProgressModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 9/2/25.
//

struct QuestionProgressModel: Codable {
    var questionId: Int
    var questionStudyCount: Int
    var updatedAt: Date?
    
    init(questionId: Int, questionStudyCount: Int, updatedAt: Date?) {
        self.questionId = questionId
        self.questionStudyCount = questionStudyCount
        self.updatedAt = updatedAt
    }
}

extension QuestionProgressModel {
    func toJson() -> [String: Any] {
        return [
            "questionId": questionId,
            "questionStudyCount": questionStudyCount,
            "updatedAt": updatedAt?.timeIntervalSince1970 // lưu thành timestamp
        ]
    }

    static func fromJson(_ json: [String: Any]) -> QuestionProgressModel? {
        guard let questionId = json["questionId"] as? Int,
              let questionStudyCount = json["questionStudyCount"] as? Int else {
            return nil
        }

        var updatedAt: Date?
        if let timestamp = json["updatedAt"] as? TimeInterval {
            updatedAt = Date(timeIntervalSince1970: timestamp)
        }
        
        return QuestionProgressModel(
            questionId: questionId,
            questionStudyCount: questionStudyCount,
            updatedAt: updatedAt
        )
    }
}
