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

private struct Const {
    static let authKey = "authResult"
    static let usersCollectionName = "users"
    static let avatarPath = "avatar"
}

class UserManager {
    private let firebaseAuth = Auth.auth()
    private var database = Firestore.firestore()
    static var shared = UserManager()
    func getUser() -> UserModel? {
        let userFirebase = firebaseAuth.currentUser
        let urlImage = userFirebase?.photoURL?.absoluteString
        return UserModel(id: userFirebase?.uid ?? "", fullName: userFirebase?.displayName ?? "",
                    nickname: userFirebase?.email ?? "", dateOfBirth: Date(),
                    phoneNumber: userFirebase?.phoneNumber ?? "084",
                    gender: Gender.others, avtURL: urlImage ?? "")
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
            "avtURL": user?.avtURL ?? "",
        ]
        if let userId = user?.id {
            let usersRef = self.database.collection(Const.usersCollectionName).document(userId)
            usersRef.getDocument { docSnapshot, err in
                if err != nil {
                    print(err as Any)
                } else if docSnapshot?.exists == false {
                    self.database.collection(Const.usersCollectionName).document(userId).setData(userData)
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
        if Auth.auth().currentUser != nil {
          return true
        } else {
          return false
        }
    }

    func setProfile() {

    }
}
