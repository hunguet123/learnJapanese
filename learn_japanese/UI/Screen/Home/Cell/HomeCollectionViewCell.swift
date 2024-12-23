//
//  HomeCollectionViewCell.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 3/8/24.
//

import UIKit

protocol HomeCollectionViewDelegate: AnyObject {
    func homeCollectionView(_ homeCollectionViewCell: HomeCollectionViewCell, didSelectAt: Int)
}

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lessonProgressView: TapableView!
    @IBOutlet weak var lessonNameLavel: UILabel!
    @IBOutlet weak var lessonLockedImage: UIImageView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet var childrenOfProgressStackView: [UIView]!
    
    var delegate: HomeCollectionViewDelegate?
    private var selectedItemAt: Int?
    
    func bind(lessonOverviewModel: LessonDTO?,cellForItemAt indexPath: IndexPath) {
        self.selectedItemAt = indexPath.row
        if indexPath.row == 0 {
            progressStackView.isHidden = true
        } else {
            progressStackView.isHidden = false
        }
        let lessonProgressView = LessonProgressView()
        lessonProgressView.backgroundColor = .clear
        lessonProgressView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        lessonProgressView.center = self.lessonProgressView.center
        lessonProgressView.totalDots = lessonOverviewModel?.totalExercises ?? 0
        lessonProgressView.completedDots = lessonOverviewModel?.completedExercises ?? 0
        lessonProgressView.fixInView(self.lessonProgressView)
        lessonNameLavel.text = lessonOverviewModel?.lesssonModel.title
        if lessonOverviewModel?.isAccessible == true {
            self.lessonLockedImage.isHidden = true
            self.lessonProgressView.isHidden = false
            childrenOfProgressStackView.forEach { view in
                view.backgroundColor = AppColors.goldenPoppy
            }
        } else {
            self.lessonLockedImage.isHidden = false
            self.lessonProgressView.isHidden = true
            childrenOfProgressStackView.forEach { view in
                view.backgroundColor = AppColors.chineseSliver
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLesson(_:)))
        self.lessonProgressView.addGestureRecognizer(tapGesture)
        self.lessonProgressView.isUserInteractionEnabled = true
    }
    
    @objc private func didTapLesson(_ sender: UIButton) {
        if let selectedItemAt = self.selectedItemAt {
            delegate?.homeCollectionView(self, didSelectAt: selectedItemAt)
        }
    }
}
