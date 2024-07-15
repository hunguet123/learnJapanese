//
//  NavigationControllerExtension.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 15/7/24.
//

import UIKit

extension UINavigationController {
    public func popAndPush(viewController: UIViewController, animated: Bool) {
        self.setViewControllers([viewController], animated: animated)
    }
}
