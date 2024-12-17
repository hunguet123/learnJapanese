import Foundation
import SQLite

enum LessonLevel: String {
    case N5 = "N5"
    case N4 = "N4"
    case N3 = "N3"
}

struct LessonModel {
    var lessonId: Int // INTEGER NOT NULL UNIQUE
    var title: String // TEXT NOT NULL
    var detail: String? // TEXT (có thể là nil)
    var level: String // TEXT NOT NULL
    
    // Khởi tạo
    init(lessonId: Int, title: String, detail: String?, level: String) {
        self.lessonId = lessonId
        self.title = title
        self.detail = detail
        self.level = level
    }
}
