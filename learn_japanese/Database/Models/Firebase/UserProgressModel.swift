import Foundation

struct UserProgressModel: Codable {
    var lessons: [LessonProgressModel]

    init(lessons: [LessonProgressModel] = []) {
        self.lessons = lessons
    }
}

extension UserProgressModel {
    func toJson() -> [String: Any] {
        let lessonObjects = lessons.map { $0.toJson() }
        return ["lessons": lessonObjects]
    }

    static func fromJson(_ json: [String: Any]) -> UserProgressModel? {
        guard let lessonsJson = json["lessons"] as? [[String: Any]] else { return nil }
        let lessonModels = lessonsJson.compactMap { LessonProgressModel.fromJson($0) }
        return UserProgressModel(lessons: lessonModels)
    }
}
