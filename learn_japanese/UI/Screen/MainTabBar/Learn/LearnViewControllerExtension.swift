//
//  LearnViewControllerExtension.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 6/8/24.
//

import Foundation
import UIKit

extension LearnViewController: UICollectionViewDelegate,
                               UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.learnViewModel?.exerciseDTOs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LessonCollectionViewCell", for: indexPath) as? LessonCollectionViewCell {
            if let exerciseDTO = self.learnViewModel?.exerciseDTOs[indexPath.row] {
                cell.delegate = self
                cell.bind(exerciseDTO: exerciseDTO, indexPath: indexPath)
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension LearnViewController: LessonCollectionViewDelegate {
    func lessonCollectionViewCell(_ lessonCollectionViewCell: LessonCollectionViewCell, didSelectAt: Int) {
        let learnSectionViewController = LearnSectionViewController()
        if let exerciseId = self.learnViewModel?.exerciseDTOs[didSelectAt].exerciseModel.exerciseId, let lessonId = self.lessonId {
            learnSectionViewController.exerciseId = exerciseId
            learnSectionViewController.lessonId = lessonId
            self.navigationController?.pushViewController(learnSectionViewController, animated: true)
        }
    }
}
