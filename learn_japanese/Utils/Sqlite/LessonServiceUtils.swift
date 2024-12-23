//
//  LessonServiceUtils.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 17/12/24.
//

import SQLite

class LessonServiceUtils {
        static func getLesson(byLevel levelJapanese: String) -> [LessonModel] {
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
            
            let query = lessonTable
                .filter(level == levelJapanese)
                .order(lessonID.asc)
            
            for row in try db.prepare(query) {
                let lesson = LessonModel(
                    lessonId: row[lessonID],
                    title: row[title],
                    detail: row[detail],
                    level: row[level]
                )
                lessons.append(lesson)
            }
        } catch {
            print("Error fetching lessons: \(error)")
        }
        
        return lessons
    }
}
