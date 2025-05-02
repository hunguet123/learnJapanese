//
//  ReviewViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 24/4/25.
//

import UIKit

class ReviewViewController: UIViewController {
    var reviewViewModel: ReviewViewModel = ReviewViewModel()
    private var indicator: UIActivityIndicatorView = {
         let activityIndicator = UIActivityIndicatorView(style: .large)
         return activityIndicator
     }()
    
    @IBOutlet weak var uiCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.fixInView(self.view)
        self.uiCollectionView.dataSource = self
        self.uiCollectionView.delegate = self
        self.uiCollectionView.register(UINib(nibName: "ReviewCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ReviewCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator.isHidden = false
        indicator.startAnimating()
        UserProgressManager.shared.fetchUserProgress { _ in
            self.reviewViewModel.getReviewData()
            self.uiCollectionView.reloadData()
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
        }
    }
}

extension ReviewViewController: UICollectionViewDataSource,
                                UICollectionViewDelegate,
                                UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewViewModel.exerciseDTOs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCollectionViewCell", for: indexPath) as? ReviewCollectionViewCell {
            cell.configure(with: reviewViewModel.exerciseDTOs[indexPath.row], cellForItemAt: indexPath)
            cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
    }
}

extension ReviewViewController: ReviewCollectionViewCellDelegate {
    func didTapReview(for cell: ReviewCollectionViewCell, cellForItemAt indexPath: IndexPath) {
        let exerciseDTO = reviewViewModel.exerciseDTOs[indexPath.row]
       let questionProgressModels = UserProgressManager.shared.getQuestionsToReviewCombined(lessonId: exerciseDTO.exerciseModel.lessonId, exerciseId: exerciseDTO.exerciseModel.exerciseId)
        let learnSectionViewController = LearnSectionViewController()
        learnSectionViewController.learnType = .Review
        learnSectionViewController.questionProgressModels = questionProgressModels
        learnSectionViewController.exerciseId = exerciseDTO.exerciseModel.exerciseId
        learnSectionViewController.lessonId = exerciseDTO.exerciseModel.lessonId
        self.navigationController?.pushViewController(learnSectionViewController, animated: true)
    }
}
