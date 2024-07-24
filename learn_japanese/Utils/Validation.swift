//
//  Validation.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 24/7/24.
//

import Foundation

class Validation {
    static func hasMinimumLength(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    static func hasUppercaseCharacter(_ password: String) -> Bool {
        let uppercaseRegEx = ".*[A-Z]+.*"
        let uppercaseTest = NSPredicate(format: "SELF MATCHES %@", uppercaseRegEx)
        return uppercaseTest.evaluate(with: password)
    }
    
    static func hasSpecialCharacter(_ password: String) -> Bool {
        let specialCharacterRegEx = ".*[!@#$%^&*(),.?\":{}|<>]+.*"
        let specialCharacterTest = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegEx)
        return specialCharacterTest.evaluate(with: password)
    }
}
