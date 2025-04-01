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
    func didTapNextQuestion(isCorrect: Bool, questionId: Int, correctAnswer: String)
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
        audioName = nil
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
                    let textSelection = TextSelectionView()
                    textSelection.fixInView(content)
                    if let questionText = questionContent["questionText"] as? String {
                        textSelection.addQuestionText(text: questionText)
                    }
                    
                    if let image = questionContent["imageName"] as? String {
                        textSelection.addQuestionImage(image: UIImage(named: image))
                    }
                    
                    if let audio = questionContent["audio"] as? String {
                        audioName = audio
                        textSelection.addQuestionAudio(questionAudio: audio)
                    }
                    
                    if let note = questionContent["note"] as? String {
                        textSelection.addNote(note: note)
                    }
                    
                    if let options = (questionContent["options"] as? [[String: Any]])?.shuffled() {
                        var correctAnswer: String = ""
                        for index in 0..<options.count {
                            if let text = options[index]["text"] as? String {
                                if let isCorrect = options[index]["isCorrect"] as? Bool, isCorrect == true {
                                    correctAnswer = text
                                }
                                textSelection.addOption(title: text,
                                                        audioName: options[index]["audio"] as? String ?? "")
                            }
                        }
                        
                        textSelection.didTapNextQuestion = { questionIndex in
                            if let isCorrect = options[questionIndex]["isCorrect"] as? Bool {
                                self.delegate?.didTapNextQuestion(isCorrect: isCorrect,
                                                                  questionId: question.questionId,
                                                                  correctAnswer: correctAnswer)
                            }
                        }
                    }
                case QuestionConstants.reading:
                    let readingView = JapaneseReadingView()
                    readingView.fixInView(content)
                    let content = ReadingModel.fromJson(questionContentString)
                    audioName = content?.audio
                    readingView.content = content
                    readingView.onReadingResult = { isCorrect in
                        self.delegate?.didTapNextQuestion(isCorrect: isCorrect,
                                                          questionId: question.questionId,
                                                          correctAnswer: "")
                    }
                    
                    readingView.onError = { error in
                        
                    }
                case QuestionConstants.matching:
                    let wordSortView = WordSortView()
                    let matchingModel = MatchingModel.fromJson(questionContentString)
                    audioName = matchingModel?.audio ?? nil
                    wordSortView.matchingModel = matchingModel
                    wordSortView.fixInView(content)
                    wordSortView.onConfirmTapped = { isCorrect in
                        self.delegate?.didTapNextQuestion(isCorrect: isCorrect,
                                                          questionId: question.questionId,
                                                          correctAnswer:  matchingModel?.correctAnswer ?? "")
                    }
                case QuestionConstants.wordMathing:
                    let wordMatchingQuestion = WordMatchingQuestion.fromJson(questionContentString)
                    let wordMatchingView = WordMatchingView()
                    wordMatchingView.wordPairs = wordMatchingQuestion?.wordPairs ?? []
                    wordMatchingView.textQuestion = wordMatchingQuestion?.questionText ?? ""
                    wordMatchingView.onDidTapContinueButton = { [weak self] in
                        self?.delegate?.didTapNextQuestion(isCorrect: true,
                                                          questionId: question.questionId,
                                                          correctAnswer:  ""
                        )
                    }
                    wordMatchingView.fixInView(content)
                case QuestionConstants.imageSelection:
                    let imageSelectionView = ImageSelectionView()
                    if let textQuestion = questionContent["questionText"] as? String {
                        imageSelectionView.textQuestion = textQuestion
                    }
                    
                    if let options = (questionContent["options"] as? [[String: Any]])?.shuffled() {
                        var correctAnswer: String = ""
                        for index in 0..<options.count {
                            if let imageName = options[index]["image"] as? String,
                               let isCorrect = options[index]["isCorrect"] as? Bool {
                                if isCorrect {
                                    correctAnswer = "Hình số \(index + 1)"
                                }
                                imageSelectionView.addOption(imageName: imageName, isSelected: isCorrect)
                            }
                        }
                        
                        imageSelectionView.onTapContinueButton = { [weak self] selectedIndex in
                            guard let selectedIndex = selectedIndex else {
                                return
                            }
                            if let isCorrect = options[selectedIndex]["isCorrect"] as? Bool {
                                self?.delegate?.didTapNextQuestion(isCorrect: isCorrect,
                                                                   questionId: question.questionId,
                                                                   correctAnswer: correctAnswer)
                            }
                        }
                    }
                        
                    if let note = questionContent["note"] as? String {
                        imageSelectionView.addNote(text: note)
                    }
                    
                    if let audioName = questionContent["audio"] as? String {
                        self.audioName = audioName
                        imageSelectionView.addAudio(audioName: audioName)
                    }
                    
                    if let translation = questionContent["translation"] as? String {
                        imageSelectionView.addTranslation(text: translation)
                    }
                    
                    imageSelectionView.fixInView(content)
                default:
                    audioName = nil
                    break
                }
            } else {
                // TODO: remove fake button
//                let button = UIButton()
//                button.setTitle("Đang phát triển", for: .normal)
//                button.backgroundColor = .systemGray
//                button.addAction(UIAction { [weak self] _ in
//                    self?.didTapNexButton(questionId: question.questionId)
//                }, for: .touchUpInside)
//                button.fixInView(content)
                let writingView = JapaneseCharacterWritingView()
                writingView.fixInView(content)
            }
        }
    }
    
    public func playAudio() {
        if let audioName = self.audioName {
            AudioUtils.shared.playSound(filename: audioName)
        }
    }
    
    // TODO: remove fake button
    @objc private func didTapNexButton(questionId: Int) {
        self.delegate?.didTapNextQuestion(isCorrect: true,
                                           questionId: questionId,
                                           correctAnswer: "")
    }
}
