//
//  ImageTextQuestionCollectionViewCell.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 11/8/24.
//

import UIKit

protocol ImageTextQuestionDelegate: AnyObject {
    func onSwipeRight(questionId: Int)
    func onSwipeLeft(questionId: Int)
}

class ImageTextQuestionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var content: UIView!
    
    var delegate: ImageTextQuestionDelegate?
    private var question: QuestionModel?
    private var audioName: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with question: QuestionModel) {
        content.removeAllSubviews()
        //TODO: remove when change db
        if let options = question.options {
            self.question = question
            if let options = DictionaryUtils.jsonStringToDictionary(jsonString: options) {
                let questionType = options["questionType"] as? String
                switch questionType {
                case QuestionConstants.characterRecognition:
                    let swipeView = SwipeView()
                    if let character = options["character"] as? String {
                        swipeView.currentCharacter = character
                        swipeView.audioName = character
                        self.audioName = character
                    }
                    
                    swipeView.fixInView(content)
                    swipeView.onSwipeRight = { character in
                        self.delegate?.onSwipeRight(questionId: question.questionId)
                    }
                    
                    swipeView.onSwipeLeft = { character in
                        self.delegate?.onSwipeLeft(questionId: question.questionId)
                    }
                case QuestionConstants.textSelection:
                    // TODO: sua lai text
                    let textSelection = TextSelectionView()
                    textSelection.fixInView(content)
                    if let questionText = options["questionText"] as? String {
                        textSelection.addQuestionText(text: questionText)
                    }
                    
                    if let options = options["options"] as? [[String: Any]] {
                        options.forEach { option in
                            if let text = option["text"] as? String {
                                textSelection.addOption(title: text)
                            }
                        }
                    }
                default:
                    break
                }
            }
        }
    }
    
    public func playAudio() {
        if !AudioUtils.shared.isPlaying() {
            if let audioName = self.audioName {
                AudioUtils.shared.playSound(filename: audioName)
            }
        }
    }
}
