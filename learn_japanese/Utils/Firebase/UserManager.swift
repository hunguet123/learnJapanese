//
//  UserManager.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 27/7/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

private struct Constants {
    static let authKey = "authResult"
    static let usersCollectionName = "users"
    static let avatarPath = "avatar"
    static let avatarNameDefault = "avatar_1"
}

class UserManager {
    private let firebaseAuth = Auth.auth()
    private var database = Firestore.firestore()
    static var shared = UserManager()
    
    private var userModel: UserModel?
    
    func fetchUserData(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let userId = firebaseAuth.currentUser?.uid else {
            completion(false)
            return
        }
        
        let userRef = database.collection(Constants.usersCollectionName).document(userId)
        
        userRef.getDocument { [weak self] document, error in
            guard let self = self else {
                completion(false)
                return
            }
            
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // Nếu document không tồn tại, tạo document mới
            guard let document = document, document.exists else {
                self.createNewUserDocument(userId: userId, completion: completion)
                return
            }
            
            // Nếu document tồn tại, lấy dữ liệu
            guard let data = document.data() else {
                completion(false)
                return
            }
            
            let userFirebase = self.firebaseAuth.currentUser
            let avatarName = data["avatarName"] as? String ?? Constants.avatarNameDefault
            
            self.userModel = UserModel(
                id: userId,
                fullName: userFirebase?.displayName ?? "",
                nickname: userFirebase?.email ?? "",
                dateOfBirth: Date(),
                phoneNumber: userFirebase?.phoneNumber ?? "084",
                gender: Gender.others,
                avatarName: avatarName
            )
            
            completion(true)
        }
    }

    // Hàm tạo document mới
    func createNewUserDocument(userId: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let userFirebase = firebaseAuth.currentUser
        
        let newUserData: [String: Any] = [
            "id": userId,
            "fullName": userFirebase?.displayName ?? "",
            "nickname": userFirebase?.email ?? "",
            "dateOfBirth": Date(),
            "phoneNumber": userFirebase?.phoneNumber ?? "084",
            "gender": Gender.others.rawValue,
            "avatarName": Constants.avatarNameDefault
        ]
        
        database.collection(Constants.usersCollectionName).document(userId).setData(newUserData) { error in
            if let error = error {
                print("Error creating new user document: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // Sau khi tạo document mới, gán dữ liệu vào userModel
            self.userModel = UserModel(
                id: userId,
                fullName: userFirebase?.displayName ?? "",
                nickname: userFirebase?.email ?? "",
                dateOfBirth: Date(),
                phoneNumber: userFirebase?.phoneNumber ?? "084",
                gender: Gender.others,
                avatarName: Constants.avatarNameDefault
            )
            
            completion(true)
        }
    }

    
    func getUser() -> UserModel? {
        return self.userModel
    }
    
    func setAvatarName(avatarName: String) {
        self.userModel?.avatarName = avatarName
    }
    
    func saveUserByFirebaseAuth() {
        let user = self.getUser()
        let birthDayFormat = user?.dateOfBirth.formatDate()
        let userData: [String: Any] = [
            "fullName": user?.fullName ?? "",
            "nickname": user?.nickname ?? "",
            "dateOfBirth": birthDayFormat ?? "",
            "phoneNumber": user?.phoneNumber ?? "",
            "gender": user?.gender.rawValue ?? "",
            "avatarName": user?.avatarName ?? Constants.avatarNameDefault
        ]
        if let userId = user?.id {
            let usersRef = self.database.collection(Constants.usersCollectionName).document(userId)
            usersRef.getDocument { docSnapshot, err in
                if let err = err {
                    print("Error fetching document: \(err)")
                } else if docSnapshot?.exists == false {
                    // Nếu document không tồn tại, tạo mới
                    usersRef.setData(userData) { err in
                        if let err = err {
                            print("Error creating document: \(err)")
                        } else {
                            print("Document created successfully")
                        }
                    }
                } else {
                    // Nếu document đã tồn tại, cập nhật
                    usersRef.updateData(userData) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document updated successfully")
                        }
                    }
                }
            }
        }
    }

    func getUserId() -> String? {
        return firebaseAuth.currentUser?.uid
    }
    
    func signOut() -> Bool {
        do {
            try firebaseAuth.signOut()
            return true
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            return false
        }
    }
    
    func isLoginBefore() -> Bool {
        return Auth.auth().currentUser != nil && userModel != nil
    }
    
    func setProfile() {
        // Implementation for setting profile
    }
}
