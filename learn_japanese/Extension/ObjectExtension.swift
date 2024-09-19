//
//  ObjectExtension.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 19/9/24.
//

import Foundation
import RealmSwift

extension Object {
    func toFirestoreDictionary() -> [String: Any] {
        var dict = [String: Any]()
        let properties = self.objectSchema.properties.map { $0.name }
        
        for property in properties {
            if let value = self.value(forKey: property) as? List<String> {
                dict[property] = Array(value)
            } else {
                dict[property] = self.value(forKey: property)
            }
        }
        
        return dict
    }
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        let properties = Mirror(reflecting: self).children
        
        for property in properties {
            if let key = property.label {
                if let value = property.value as? List<String> {
                    dict[key] = Array(value)
                } else {
                    dict[key] = property.value
                }
            }
        }
        
        return dict
    }
}
