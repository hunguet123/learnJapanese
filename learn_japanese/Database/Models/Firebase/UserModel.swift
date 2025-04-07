//
//  UserModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 26/8/24.
//


import Foundation

class UserModel {
    var id: String
    var nickname: String
    var email: String
    var avatarName: String

    init(id: String,
         nickname: String,
         email: String,
         avatarName: String) {
        self.id = id
        self.nickname = nickname
        self.email = email
        self.avatarName = avatarName
    }
}
