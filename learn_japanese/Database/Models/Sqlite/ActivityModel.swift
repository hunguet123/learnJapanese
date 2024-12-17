//
//  ActivityModel.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 17/12/24.
//

import Foundation

struct ActivityModel {
    let activityId: Int
    let activityNumber: Int
    let detail: String?
    let lessonId: Int
    
    init(activityId: Int, activityNumber: Int, detail: String?, lessonId: Int) {
        self.activityId = activityId
        self.activityNumber = activityNumber
        self.detail = detail
        self.lessonId = lessonId
    }
}
