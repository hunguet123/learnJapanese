//
//  LearnSectionViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 8/8/24.
//

import UIKit

class LearnSectionViewController: UIViewController {
    @IBOutlet weak var learningProgressView: UIProgressView!
    @IBOutlet weak var quizCollectionView: UICollectionView!
    
    let learnSectionViewModel: LearnSectionViewModel = LearnSectionViewModel()
    
    var exerciseId: Int = 0
    var lessonId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        learnSectionViewModel.fetchAllQuestions(byExcerciseId: exerciseId)
    }
    
    private func setUpView() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.quizCollectionView.register(UINib(nibName: "ImageTextQuestionCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImageTextQuestionCollectionViewCell")
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
            UserProgressManager.shared.updateExerciseProgress(lessonId: lessonId, exerciseId: exerciseId, score: learnSectionViewModel.score, maxScore: learnSectionViewModel.questions.count, wrongQuestionIds: learnSectionViewModel.wrongQuestionIds, completed: true) { firebaseResult in
                print("------ firebase Result \(firebaseResult)")
                UserProgressManager.shared.fetchUserProgress { result in
                    print("fetch userProgress: \(result)")
                }
            }
        }
    }
}
