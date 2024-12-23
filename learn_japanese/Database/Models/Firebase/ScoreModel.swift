//
//  ScoreModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 22/12/24.
//

struct ScoreModel: Codable {
    var value: Int
    var max: Int

    init(value: Int, max: Int) {
        self.value = value
        self.max = max
    }
}

extension ScoreModel {
    func toJson() -> [String: Any] {
        return [
            "value": value,
            "max": max
        ]
    }

    static func fromJson(_ json: [String: Any]) -> ScoreModel? {
        guard let value = json["value"] as? Int,
              let max = json["max"] as? Int else { return nil }
        return ScoreModel(value: value, max: max)
    }
}
