//
//  dictionary_utils.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 14/1/25.
//

import Foundation

import Foundation

class DictionaryUtils {
    
    // Hàm chuyển đổi chuỗi JSON thành Dictionary
    static func jsonStringToDictionary(jsonString: String) -> [String: Any]? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Error converting string to Data")
            return nil
        }
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return dictionary
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    // Hàm chuyển đổi Dictionary thành chuỗi JSON
    static func dictionaryToJsonString(dictionary: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error encoding Dictionary to JSON: \(error)")
            return nil
        }
    }
}

