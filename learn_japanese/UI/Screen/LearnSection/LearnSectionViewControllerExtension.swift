//
//  LearnSectionViewControllerExtension.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 8/8/24.
//

import Foundation
import UIKit

extension LearnSectionViewController: UICollectionViewDelegate,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageTextQuestionCollectionViewCell", for: indexPath) as? ImageTextQuestionCollectionViewCell {
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        self.learningProgressView.progress = Float(currentPage + 1) / 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension LearnSectionViewController: ConfirmDialogDelegate {
    func confirmDialogDidTapAccept(_ confirmDialog: ConfirmDialog) {
        self.navigationController?.popViewController(animated: true)
    }
}
