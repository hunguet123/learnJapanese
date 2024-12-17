//
//  UserProgressManager.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 16/12/24.
//

import Foundation

import FirebaseFirestore

enum FirebaseResult {
    case success
    case failure(Error)
}

class UserProgressManager {
    private let db = Firestore.firestore()
    private let collectionName = "userProgress"
    
    static let shared = UserProgressManager()
    
    func addExerciseProgress(
        userId: String,
        exerciseId: Int,
        totalAttempts: Int,
        wrongAttempts: Int,
        completed: Bool,
        completion: @escaping (FirebaseResult) -> Void
    ) {
        let documentRef = db.collection("userProgress").document(userId)
        
        // Dữ liệu mới cho bài tập
        let newProgressData: [String: Any] = [
            "completed": completed,
            "progress": completed ? 1.0 : 0.0,
            "lastUpdated": FieldValue.serverTimestamp(),
            "totalAttempts": totalAttempts,
            "wrongAttempts": wrongAttempts
        ]
        
        documentRef.getDocument { document, error in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let document = document, document.exists {
                // Document tồn tại
                if let progress = document.data()?["progress"] as? [String: Any] {
                    if progress["\(exerciseId)"] == nil {
                        // Nếu exerciseId chưa tồn tại -> thêm mới
                        let fieldPath = "progress.\(exerciseId)"
                        documentRef.updateData([fieldPath: newProgressData]) { error in
                            if let error = error {
                                print("Error updating progress: \(error.localizedDescription)")
                                completion(.failure(error))
                            } else {
                                print("Progress updated successfully")
                                completion(.success)
                            }
                        }
                    } else {
                        // ExerciseId đã tồn tại
                        print("Exercise \(exerciseId) already exists in progress")
                        completion(.success)
                    }
                } else {
                    print("Progress key is missing or has invalid format. Adding progress key.")
                    let fieldPath = "progress.\(exerciseId)"
                    documentRef.updateData([fieldPath: newProgressData]) { error in
                        if let error = error {
                            print("Error adding progress key: \(error.localizedDescription)")
                            completion(.failure(error))
                        } else {
                            completion(.success)
                        }
                    }
                }
            } else {
                // Document không tồn tại -> tạo mới
                print("Document does not exist. Creating a new document.")
                let initialData: [String: Any] = [
                    "progress": [
                        "exerciseId\(exerciseId)": newProgressData
                    ]
                ]
                documentRef.setData(initialData, merge: true) { error in
                    if let error = error {
                        print("Error creating document: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        print("Document created successfully with progress")
                        completion(.success)
                    }
                }
            }
        }
    }

    
    func updateExerciseProgress(
        userId: String,
        exerciseId: String,
        totalAttempts: Int,
        wrongAttempts: Int,
        completed: Bool,
        completion: @escaping (FirebaseResult) -> Void
    ) {
        let documentRef = db.collection("userProgress").document(userId)
        
        // Dữ liệu cập nhật cho bài tập
        let updatedProgressData: [String: Any] = [
            "completed": completed,
            "progress": completed ? 1.0 : 0.0,
            "lastUpdated": FieldValue.serverTimestamp(),
            "totalAttempts": totalAttempts,
            "wrongAttempts": wrongAttempts
        ]
        
        let fieldPath = "progress.\(exerciseId)"
        
        // Sử dụng `setData` với merge để cập nhật tiến độ
        documentRef.setData([fieldPath: updatedProgressData], merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success)
            }
        }
    }
}

