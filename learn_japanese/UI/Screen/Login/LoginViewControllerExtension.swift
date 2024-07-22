//
//  LoginViewControllerExtension.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 17/7/24.
//

import UIKit

extension LoginViewController: DefaultTabBarViewDelegate {
    func tabBar(_ tabBar: DefaultTabBarView, didSelectItemAt index: Int) {
        let tabWidth = tabViewScroll.frame.width
        tabViewScroll.setContentOffset(CGPoint(x: tabWidth * Double(index), y: 0), animated: true)
    }
}

extension LoginViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let tabWidth = tabViewScroll.frame.width
        let currentTab = Int(scrollView.contentOffset.x / tabWidth)
        tabBarView.selectTab(at: currentTab)
    }
}
