//
//  File.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 17/12/24.
//

import SQLite

class QuestionServiceUtils {
    static func fetchAllQuestions(by exerciseId: Int) -> [QuestionModel] {
        guard let db = SQLiteHelper.shared.db else {
            print("Database connection is nil")
            return []
        }
        
        var questions: [QuestionModel] = []
        
        do {
            // Khai báo bảng và cột
            let questionTable = Table("Question")
            let questionId = Expression<Int>("question_id")
            let exerciseIdColumn = Expression<Int>("exercise_id")
            let questionText = Expression<String?>("question_text")
            let options = Expression<String?>("options")
            let correctAnswer = Expression<String?>("correct_answer")
            let image = Expression<String?>("image")
            let audio = Expression<String?>("audio")
            let questionType = Expression<String?>("question_type")
            
            // Truy vấn với điều kiện lọc exercise_id
            let query = questionTable
                .filter(exerciseIdColumn == exerciseId)
                .order(questionId.asc) // Sắp xếp theo question_id tăng dần
            
            // Duyệt qua các hàng và tạo QuestionModel
            for row in try db.prepare(query) {
                let question = QuestionModel(
                    questionId: row[questionId],
                    exerciseId: row[exerciseIdColumn],
                    questionText: row[questionText],
                    options: row[options],
                    correctAnswer: row[correctAnswer],
                    image: row[image],
                    audio: row[audio],
                    questionType: row[questionType]
                )
                questions.append(question)
            }
        } catch {
            print("Error fetching questions: \(error)")
        }
        
        return questions
    }
}
