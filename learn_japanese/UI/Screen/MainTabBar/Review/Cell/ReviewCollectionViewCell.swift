//
//  ReviewCollectionViewCell.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 2/5/25.
//

import UIKit

protocol ReviewCollectionViewCellDelegate {
    func didTapReview(for cell: ReviewCollectionViewCell, cellForItemAt indexPath: IndexPath)
}

class ReviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var accuracyProgressView: UIProgressView!
    @IBOutlet weak var accuracyLabel: UILabel!
    var delegate: ReviewCollectionViewCellDelegate?
    private var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with exercise: ExerciseDTO,
                          cellForItemAt indexPath: IndexPath) {
        self.indexPath = indexPath
        let accuracy = exercise.accuracy ?? 0.0
        let accuracyString = String(format: "%.2f", accuracy)

        self.title.text = exercise.exerciseModel.title
        self.accuracyLabel.text = "\(LocalizationText.accuracyRate): \(accuracyString)%"
        self.accuracyProgressView.progress = Float(accuracy)
        if accuracy < 0.5 {
            self.accuracyProgressView.progressTintColor = .red
        } else {
            self.accuracyProgressView.progressTintColor = AppColors.goldenPoppy
        }
    }

    @IBAction func didTapReview(_ sender: Any) {
        guard let indexPath = self.indexPath else {
            return
        }
        self.delegate?.didTapReview(for: self, cellForItemAt: indexPath)
    }
}
