//
//  LessonCollectionViewCell.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 6/8/24.
//

import UIKit

protocol LessonCollectionViewDelegate {
    func lessonCollectionViewCell(_ lessonCollectionViewCell: LessonCollectionViewCell, didSelectAt: Int)
}

class LessonCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var stateLearnedImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    private var indexPath: IndexPath?
    var delegate: LessonCollectionViewDelegate?
    
    func bind(section: SectionModel, indexPath: IndexPath) {
        self.nameLabel.text = section.name
        self.indexPath = indexPath
        guard let contentUIView = self.contentView as? TapableView else {
            return
        }
        
        if section.isLearned == false {
            contentUIView.backgroundColor = AppColors.lightSliver
            contentUIView.isUserInteractionEnabled = false
            self.stateLearnedImage.image = AppImages.iconLock
        } else {
            contentUIView.backgroundColor = AppColors.white
            contentUIView.isUserInteractionEnabled = true
            self.stateLearnedImage.image = AppImages.iconCheckmarkCircle
        }
    }
    @IBAction func didTapLesson(_ sender: Any) {
        if let indexPath = self.indexPath {
            self.delegate?.lessonCollectionViewCell(self, didSelectAt: indexPath.row)
        }
    }
}
