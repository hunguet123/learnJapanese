//
//  ExcerciseServiceUtils.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 17/12/24.
//

import SQLite

class ExerciseServiceUtils {
    static func getExercise(byActivityId activityId: Int) -> [ExerciseModel] {
        guard let db = SQLiteHelper.shared.db else {
            print("Database connection is nil")
            return []
        }
        
        var exercises: [ExerciseModel] = []
        
        do {
            // Khai báo bảng và cột
            let exerciseTable = Table("Exercise")
            let exerciseId = Expression<Int>("excercise_id")
            let exerciseNumber = Expression<String>("exercise_number")
            let activityIdColumn = Expression<Int>("activity_id")
            let title = Expression<String?>("title")
            let description = Expression<String?>("description")
            
            // Truy vấn với điều kiện lọc activity_id
            let query = exerciseTable
                .filter(activityIdColumn == activityId)
                .order(exerciseNumber.asc) // Sắp xếp theo exercise_number tăng dần
            
            // Duyệt qua các hàng và tạo ExerciseModel
            for row in try db.prepare(query) {
                let exercise = ExerciseModel(
                    exerciseId: row[exerciseId],
                    exerciseNumber: row[exerciseNumber],
                    activityId: row[activityIdColumn],
                    title: row[title],
                    description: row[description]
                )
                exercises.append(exercise)
            }
        } catch {
            print("Error fetching exercises: \(error)")
        }
        
        return exercises
    }
}

