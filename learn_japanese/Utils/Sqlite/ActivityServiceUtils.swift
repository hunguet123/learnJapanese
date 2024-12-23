//
//  ActivityServiceUtils.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 17/12/24.
//

import SQLite

class ActivityServiceUtils {
    static func getActivity(byLessonId lessonId: Int) -> [ActivityModel] {
        guard let db = SQLiteHelper.shared.db else {
            print("Database connection is nil")
            return []
        }
        
        var activities: [ActivityModel] = []
        
        do {
            // Khai báo bảng và cột
            let activityTable = Table("Activity")
            let activityId = Expression<Int>("activity_id")
            let activityNumber = Expression<Int>("activity_number")
            let detail = Expression<String?>("detail")
            let lessonIdColumn = Expression<Int>("lesson_id")
            
            // Truy vấn với điều kiện lọc lesson_id
            let query = activityTable
                .filter(lessonIdColumn == lessonId)
                .order(activityId.asc) // Sắp xếp theo activity_id tăng dần
            
            // Duyệt qua các hàng và tạo ActivityModel
            for row in try db.prepare(query) {
                let activity = ActivityModel(
                    activityId: row[activityId],
                    activityNumber: row[activityNumber],
                    detail: row[detail],
                    lessonId: row[lessonIdColumn]
                )
                activities.append(activity)
            }
        } catch {
            print("Error fetching activities: \(error)")
        }
        
        return activities
    }
}

