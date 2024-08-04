//
//  HomeCollectionViewCell.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 3/8/24.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lessonProgressView: UIView!
    @IBOutlet weak var lessonNameLavel: UILabel!
    @IBOutlet weak var lessonLockedImage: UIImageView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet var childrenOfProgressStackView: [UIView]!
    
    func bind(lessonOverviewViewModel: LessonOverviewViewModel?,cellForItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            progressStackView.isHidden = true
        } else {
            progressStackView.isHidden = false
        }
        let lessonProgressView = LessonProgressView()
        lessonProgressView.backgroundColor = .clear
        lessonProgressView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        lessonProgressView.center = self.lessonProgressView.center
        lessonProgressView.totalDots = lessonOverviewViewModel?.totalNumberOfLessons ?? 0
        lessonProgressView.completedDots = lessonOverviewViewModel?.numberOfLesssonsLearned ?? 0
        lessonProgressView.fixInView(self.lessonProgressView)
        lessonNameLavel.text = lessonOverviewViewModel?.name
        if lessonOverviewViewModel?.isCanLearn == true {
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
    }
}
