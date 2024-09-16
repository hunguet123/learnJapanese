//
//  VocabularyModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 19/8/24.
//

import RealmSwift

class VocabularyModel: Object, RealmInitializable {
    @objc dynamic var id: String = ""
    @objc dynamic var word: String = ""
    @objc dynamic var hiragana: String = ""
    @objc dynamic var kanji: String? = nil
    @objc dynamic var exampleSentence: String? = nil
    @objc dynamic var englishMeaning: String? = nil
    @objc dynamic var vietnameseMeaning: String? = nil
    @objc dynamic var audioURL: String? = nil

    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init?(value: [String: Any]) {
        self.init()
        self.id = value["id"] as? String ?? ""
        self.word = value["word"] as? String ?? ""
        self.hiragana = value["hiragana"] as? String ?? ""
        self.kanji = value["kanji"] as? String
        self.exampleSentence = value["exampleSentence"] as? String
        self.englishMeaning = value["englishMeaning"] as? String
        self.vietnameseMeaning = value["vietnameseMeaning"] as? String
        self.audioURL = value["audioURL"] as? String
    }

    convenience init(id: String, word: String, hiragana: String, kanji: String?,
                     exampleSentence: String?, englishMeaning: String?,
                     vietnameseMeaning: String?, audioURL: String?) {
        self.init()
        self.id = id
        self.word = word
        self.hiragana = hiragana
        self.kanji = kanji
        self.exampleSentence = exampleSentence
        self.englishMeaning = englishMeaning
        self.vietnameseMeaning = vietnameseMeaning
        self.audioURL = audioURL
    }
}
