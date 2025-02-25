//
//  ImageTextQuestionCollectionViewCell.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 11/8/24.
//

import UIKit

protocol ImageTextQuestionCollectionViewCellDelegate: AnyObject {
    func onSwipeRight(questionId: Int)
    func onSwipeLeft(questionId: Int)
    func didTapNextQuestion(isCorrect: Bool, questionId: Int)
}

class ImageTextQuestionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var content: UIView!
    
    var delegate: ImageTextQuestionCollectionViewCellDelegate?
    private var question: QuestionModel?
    private var audioName: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with question: QuestionModel) {
        content.removeAllSubviews()
        //TODO: remove when change db
        if let questionContentString = question.questionContent {
            self.question = question
            if let questionContent = DictionaryUtils.jsonStringToDictionary(jsonString: questionContentString) {
                let questionType = questionContent["questionType"] as? String
                switch questionType {
                case QuestionConstants.characterRecognition:
                    let swipeView = SwipeView()
                    if let character = questionContent["character"] as? String {
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
                    audioName = nil
                    let textSelection = TextSelectionView()
                    textSelection.fixInView(content)
                    if let questionText = questionContent["questionText"] as? String {
                        textSelection.addQuestionText(text: questionText)
                    }
                    
                    if let options = questionContent["options"] as? [[String: Any]] {
                        for index in 0..<options.count {
                            if let text = options[index]["text"] as? String {
                                textSelection.addAudioItem(audioName: options[index]["audio"] as? String ?? "")
                                textSelection.addOption(title: text)
                            }
                        }
                        textSelection.didTapNextQuestion = { questionIndex in
                            if let isCorrect = options[questionIndex]["isCorrect"] as? Bool {
                                self.delegate?.didTapNextQuestion(isCorrect: isCorrect, questionId: question.questionId)
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
