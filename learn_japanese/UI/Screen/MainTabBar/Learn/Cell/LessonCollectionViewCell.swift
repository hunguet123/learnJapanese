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
    
    func bind(exerciseDTO: ExerciseDTO, indexPath: IndexPath) {
        self.nameLabel.text = exerciseDTO.exerciseModel.title
        self.indexPath = indexPath
        guard let contentUIView = self.contentView as? TapableView else {
            return
        }
        
        switch exerciseDTO.state {
        case .cantLearn:
            contentUIView.backgroundColor = AppColors.lightSliver
            contentUIView.isUserInteractionEnabled = false
            self.stateLearnedImage.isHidden = false
            self.stateLearnedImage.image = AppImages.iconLock
        case .learned:
            contentUIView.backgroundColor = AppColors.white
            contentUIView.isUserInteractionEnabled = true
            self.stateLearnedImage.image = AppImages.iconCheckmarkCircle
            self.stateLearnedImage.isHidden = false
        case .canLearn:
            contentUIView.backgroundColor = AppColors.white
            contentUIView.isUserInteractionEnabled = true
            self.stateLearnedImage.isHidden = true
        }
    }
    @IBAction func didTapLesson(_ sender: Any) {
        if let indexPath = self.indexPath {
            self.delegate?.lessonCollectionViewCell(self, didSelectAt: indexPath.row)
        }
    }
}
