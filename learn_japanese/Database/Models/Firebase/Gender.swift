//
//  Gender.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 26/8/24.
//

import Foundation

enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case others = "Others"

    func name() -> String {
        return self.rawValue
    }

    static func listGenders() -> [String] {
        return Gender.allCases.map {
            $0.name()
        }
    }
}
