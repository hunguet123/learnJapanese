import Foundation

struct UserProgressModel: Codable {
    var lessons: [LessonProgressModel]
    var currentLevel: String? // Thêm biến lưu trình độ hiện tại

    init(lessons: [LessonProgressModel] = [], currentLevel: String? = nil) {
        self.lessons = lessons
        self.currentLevel = currentLevel
    }
}

extension UserProgressModel {
    func toJson() -> [String: Any] {
        let lessonObjects = lessons.map { $0.toJson() }
        var dict: [String: Any] = ["lessons": lessonObjects]
        if let currentLevel = currentLevel {
            dict["currentLevel"] = currentLevel
        }
        return dict
    }

    static func fromJson(_ json: [String: Any]) -> UserProgressModel? {
        guard let lessonsJson = json["lessons"] as? [[String: Any]] else { return nil }
        let lessonModels = lessonsJson.compactMap { LessonProgressModel.fromJson($0) }
        let currentLevel = json["currentLevel"] as? String
        return UserProgressModel(lessons: lessonModels, currentLevel: currentLevel)
    }
}
