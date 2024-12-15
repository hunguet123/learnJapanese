import Foundation
import SQLite

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

extension LessonModel {
    static func fetchAllLessons() -> [LessonModel] {
        var lessons: [LessonModel] = []
        guard let db = SQLiteHelper.shared.db else {
            return lessons;
        }
        
        do {
            let lessonTable = Table("Lesson")
            let lessonID = Expression<Int>("lesson_id")
            let title = Expression<String>("title")
            let detail = Expression<String?>("detail")
            let level = Expression<String>("level")
            for row in try db.prepare(lessonTable) {
                let lesson = LessonModel(
                    lessonId: row[lessonID],
                    title: row[title],
                    detail: row[detail],
                    level: row[level]
                )
                lessons.append(lesson)
            }
            
        } catch {
            print("Error: \(error)")
        }
        
        return lessons
    }
}
