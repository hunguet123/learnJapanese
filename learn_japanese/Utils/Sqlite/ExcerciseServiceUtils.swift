//
//  ExcerciseServiceUtils.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 17/12/24.
//

import SQLite

class ExerciseServiceUtils {
    static func getExercises(byLessonId lessonId: Int) -> [ExerciseModel] {
        guard let db = SQLiteHelper.shared.db else {
            print("Database connection is nil")
            return []
        }
        
        var exercises: [ExerciseModel] = []
        
        do {
            // Khai báo bảng và cột
            let exerciseTable = Table("Exercise")
            let exerciseId = Expression<Int>("exercise_id")
            let exerciseNumber = Expression<Double>("exercise_number")
            let lessonIdColumn = Expression<Int>("lesson_id")
            let title = Expression<String?>("title")
            let description = Expression<String?>("description")
            
            let query = exerciseTable
                .filter(lessonIdColumn == lessonId)
                .order(exerciseId.asc) // Sắp xếp theo exercise_number tăng dần
            
            // Duyệt qua các hàng và tạo ExerciseModel
            for row in try db.prepare(query) {
                let exercise = ExerciseModel(
                    exerciseId: row[exerciseId],
                    exerciseNumber: row[exerciseNumber],
                    lessonId: row[lessonIdColumn],
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
    
    static func getExercise(byExerciseId id: Int) -> ExerciseModel? {
            guard let db = SQLiteHelper.shared.db else {
                print("Database connection is nil")
                return nil
            }
            
            do {
                let exerciseTable = Table("Exercise")
                let exerciseId = Expression<Int>("exercise_id")
                let exerciseNumber = Expression<Double>("exercise_number")
                let lessonIdColumn = Expression<Int>("lesson_id")
                let title = Expression<String?>("title")
                let description = Expression<String?>("description")
                let query = exerciseTable.filter(exerciseId == id)
                
                if let row = try db.pluck(query) {
                    let exercise = ExerciseModel(
                        exerciseId: row[exerciseId],
                        exerciseNumber: row[exerciseNumber],
                        lessonId: row[lessonIdColumn],
                        title: row[title],
                        description: row[description]
                    )
                    return exercise
                }
            } catch {
                print("Error fetching exercise by id: \(error)")
            }
            
            return nil
        }
}
