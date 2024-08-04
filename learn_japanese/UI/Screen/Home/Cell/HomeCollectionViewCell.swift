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
    
    func bind(lessonOverviewViewModel: LessonOverviewViewModel?) {
        let lessonProgressView = LessonProgressView()
        lessonProgressView.backgroundColor = .clear
        lessonProgressView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        lessonProgressView.center = self.lessonProgressView.center
        lessonProgressView.totalDots = lessonOverviewViewModel?.totalNumberOfLessons ?? 0
        lessonProgressView.completedDots = lessonOverviewViewModel?.numberOfLesssonsLearned ?? 0
        lessonProgressView.fixInView(self.lessonProgressView)
        lessonNameLavel.text = lessonOverviewViewModel?.name
    }
}
