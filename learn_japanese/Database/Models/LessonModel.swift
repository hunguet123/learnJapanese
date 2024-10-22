//
//  LessonModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 19/9/24.
//

import Foundation
import RealmSwift

class LessonModel : Object, RealmInitializable {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    let vocabularyIds = List<String>()
    let grammarIds = List<String>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, title: String, vocabularyIds: [String], grammarIds: [String]) {
        self.init()
        self.id = id
        self.title = title
        self.vocabularyIds.append(objectsIn: vocabularyIds)
        self.grammarIds.append(objectsIn: grammarIds)
    }
    
    required convenience init?(value: [String: Any]) {
        self.init()
        self.id = value["id"] as? String ?? ""
        self.title = value["title"] as? String ?? ""
        
        if let vocabularyIdsArray = value["vocabularyIds"] as? [String] {
            self.vocabularyIds.append(objectsIn: vocabularyIdsArray)
        }
        
        if let grammarIdsArray = value["grammarIds"] as? [String] {
            self.grammarIds.append(objectsIn: grammarIdsArray)
        }
    }
}
