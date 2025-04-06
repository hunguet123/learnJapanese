//
//  UserModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 26/8/24.
//


import Foundation

class UserModel {
    var id: String
    var fullName: String
    var nickname: String
    var dateOfBirth: Date
    var phoneNumber: String
    var gender: Gender
    var avatarName: String
    var completedLessonIds: [String] = []

    init(id: String, fullName: String, nickname: String,
         dateOfBirth: Date, phoneNumber: String, gender: Gender, avatarName: String) {
        self.id = id
        self.fullName = fullName
        self.nickname = nickname
        self.dateOfBirth = dateOfBirth
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.avatarName = avatarName
    }
}
