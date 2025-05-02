//
//  LearnSectionViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 8/8/24.
//

import UIKit
enum LearnType {
    case Study
    case Review
}

class LearnSectionViewController: UIViewController {
    @IBOutlet weak var learningProgressView: UIProgressView!
    @IBOutlet weak var quizCollectionView: UICollectionView!
    var learnType: LearnType = .Study
    var questionProgressModels: [QuestionProgressModel] = []
    let learnSectionViewModel: LearnSectionViewModel = LearnSectionViewModel()
    
    var exerciseId: Int = 0
    var lessonId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        switch learnType {
        case .Study:
            learnSectionViewModel.fetchAllQuestions(byExcerciseId: exerciseId)
        case .Review:
            learnSectionViewModel.fetchAllReviewQuesions(questionProgressModels: questionProgressModels)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AudioUtils.shared.stopSound()
    }
    
    private func setUpView() {
        title = LocalizationText.learn
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.quizCollectionView.register(UINib(nibName: "ImageTextQuestionCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImageTextQuestionCollectionViewCell")
    }
    
    func resetProgress() {
        learnSectionViewModel.resetAll()
        switch learnType {
        case .Study:
            learnSectionViewModel.fetchAllQuestions(byExcerciseId: exerciseId)
        case .Review:
            learnSectionViewModel.fetchAllReviewQuesions(questionProgressModels: questionProgressModels)
        }
        self.learningProgressView.setProgress(0, animated: false)
        self.quizCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @IBAction func didTapCloseLearnSection(_ sender: Any) {
        let confirmDialog = ConfirmDialog.loadView()
        confirmDialog.loadContent(type: .quitLearn)
        confirmDialog.delegate = self
        confirmDialog.show(in: self.view)
    }
    
    func nextQuestion() {
        let pageWidth = quizCollectionView.frame.width
        let currentPage = Int((quizCollectionView.contentOffset.x + pageWidth / 2) / pageWidth)
        
        // Kiểm tra xem có thể cuộn sang trang tiếp theo không
        let nextPage = currentPage + 1
        if nextPage < quizCollectionView.numberOfItems(inSection: 0) {
            let nextIndexPath = IndexPath(item: nextPage, section: 0)
            quizCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        } else {
            // Kết thúc bài học.
            UserProgressManager.shared.updateExerciseProgress(lessonId: lessonId, exerciseId: exerciseId, score: learnSectionViewModel.score, maxScore: learnSectionViewModel.questions.count, wrongQuestionIds: learnSectionViewModel.wrongQuestionIds, learnedQuestionIds: learnSectionViewModel.questions.map{$0.questionId}, completed: true) { firebaseResult in
                print("------ firebase Result \(firebaseResult)")
                let learnResultViewController = LearnResultViewController()
                learnResultViewController.learnResultViewModel = LearnResultViewModel(correctAnswer: self.learnSectionViewModel.score, wrongAnswer: self.learnSectionViewModel.wrongQuestionIds.count)
                self.navigationController?.pushViewController(learnResultViewController, animated: true)
            }
        }
    }
    
    func showAnswerModal(isCorrect: Bool, correctAnswer: String, completion: @escaping (() -> Void)) {
        let explanation = isCorrect
        ? LocalizationText.correctAnswerMessage
        : "\(LocalizationText.correctAnswerPrefix) \(correctAnswer)"
        
        let modalVC = AnswerModalViewController(
            isCorrect: isCorrect,
            explanation: explanation,
            completionHandler: completion
        )
        
        present(modalVC, animated: true, completion: nil)
    }
}
