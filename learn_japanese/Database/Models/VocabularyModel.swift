//
//  VocabularyModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 19/8/24.
//

import RealmSwift

class VocabularyModel: Object, RealmInitializable {
    @objc dynamic var word: String = ""
    @objc dynamic var meaning: String = ""
    @objc dynamic var example: String = ""
    
    override static func primaryKey() -> String? {
        return "word"
    }
    
    convenience required init?(value: [String: Any]) {
        self.init()
        guard
            let word = value["word"] as? String,
            let meaning = value["meaning"] as? String,
            let example = value["example"] as? String
        else {
            return nil
        }

        self.word = word
        self.meaning = meaning
        self.example = example
    }
    
    convenience init(work: String, meaning: String, example: String) {
        self.init()
        self.word = work
        self.meaning = meaning
        self.example = example
    }
}
