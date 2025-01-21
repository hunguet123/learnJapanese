//
//  ImageTextQuestionCollectionViewCell.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 11/8/24.
//

import UIKit

protocol ImageTextQuestionDelegate: AnyObject {
    func onSwipeRight(character: String)
    func onSwipeLeft(character: String)
}

class ImageTextQuestionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var content: UIView!
    
    var delegate: ImageTextQuestionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with question: QuestionModel) {
        content.removeAllSubviews()
        //TODO: remove when change db
        if let options = question.options {
            if let options = DictionaryUtils.jsonStringToDictionary(jsonString: options) {
                let questionType = options["questionType"] as? String
                switch questionType {
                case QuestionConstants.characterRecognition:
                    let swipeView = SwipeView()
                    if let character = options["character"] as? String {
                        swipeView.currentCharacter = character
                    }
                    
                    swipeView.fixInView(content)
                    swipeView.onSwipeRight = { character in
                        self.delegate?.onSwipeRight(character: character)
                    }
                    
                    swipeView.onSwipeLeft = { character in
                        self.delegate?.onSwipeLeft(character: character)
                    }
                default:
                    break
                }
            }
        }
    }
}
