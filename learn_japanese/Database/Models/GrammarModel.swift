//
//  GrammarModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 16/9/24.
//

import RealmSwift

class GrammarModel: Object, RealmInitializable {
    @objc dynamic var id: String = "" // Document ID từ Firestore, dùng làm khóa chính
    @objc dynamic var grammarPoint: String = "" // Điểm ngữ pháp (VD: "て-form", "た-form")
    @objc dynamic var descriptionGrammar: String? = nil // Mô tả chi tiết về điểm ngữ pháp
    @objc dynamic var exampleSentence: String? = nil // Câu ví dụ sử dụng điểm ngữ pháp
    @objc dynamic var relatedWords: String? = nil // Các từ vựng liên quan (nếu có)

    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init?(value: [String: Any]) {
         self.init()
         self.id = value["id"] as? String ?? ""
         self.grammarPoint = value["grammarPoint"] as? String ?? ""
         self.descriptionGrammar = value["descriptionGrammar"] as? String
         self.exampleSentence = value["exampleSentence"] as? String
         self.relatedWords = value["relatedWords"] as? String
     }
    
    convenience init(id: String, grammarPoint: String, descriptionGrammar: String?,
                     exampleSentence: String?, relatedWords: String?) {
            self.init()
            self.id = id
            self.grammarPoint = grammarPoint
            self.descriptionGrammar = descriptionGrammar
            self.exampleSentence = exampleSentence
            self.relatedWords = relatedWords
        }
}
