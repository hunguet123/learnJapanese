//
//  LessonCollectionViewCell.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 6/8/24.
//

import UIKit

class LessonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var stateLearnedImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func bind(section: SectionModel) {
        self.nameLabel.text = section.name
    }
}
