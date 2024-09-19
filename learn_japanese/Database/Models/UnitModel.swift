//
//  UnitModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 19/9/24.
//

import Foundation
import RealmSwift

class UnitModel: Object, RealmInitializable {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionLesson: String? = nil
    let lessonIds = List<String>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, title: String, descriptionLesson: String?, lessonIds: [String]) {
        self.init()
        self.id = id
        self.title = title
        self.descriptionLesson = descriptionLesson
        self.lessonIds.append(objectsIn: lessonIds)
    }
    
    // Khởi tạo từ dictionary
    required convenience init?(value: [String: Any]) {
        self.init()
        self.id = value["id"] as? String ?? ""
        self.title = value["title"] as? String ?? ""
        self.descriptionLesson = value["descriptionLesson"] as? String
        if let lessonIdsArray = value["lessonIds"] as? [String] {
            self.lessonIds.append(objectsIn: lessonIdsArray)
        }
    }
}
