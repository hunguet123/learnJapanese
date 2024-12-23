//
//  HomeViewControllerExtension.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 3/8/24.
//

import Foundation
import UIKit

extension HomeViewController: UICollectionViewDelegate,
                              UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.homeViewModel?.lessonDTOs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell {
            cell.delegate = self
            cell.bind(lessonOverviewModel: self.homeViewModel?.lessonDTOs[indexPath.row], cellForItemAt: indexPath)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width) / 2
        return CGSize(width: width, height: width * 1.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: -80, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension HomeViewController: HomeCollectionViewDelegate {
    func homeCollectionView(_ homeCollectionViewCell: HomeCollectionViewCell, didSelectAt: Int) {
        let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarViewController
        guard let lessonModel = self.homeViewModel?.lessonDTOs[didSelectAt].lesssonModel else {
            return
        }
        
        tabBarController.lessonId = lessonModel.lessonId
        tabBarController.lessonName = lessonModel.title
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
}
