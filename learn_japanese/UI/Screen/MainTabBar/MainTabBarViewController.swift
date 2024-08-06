//
//  MainTabBarViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 6/8/24.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    var lessonId: String?
    var lessonName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers?.forEach({ viewController in
            if let lessonViewController = viewController as? LearnViewController {
                lessonViewController.learnViewModel = LearnViewModel()
                lessonViewController.lessonId = self.lessonId
                lessonViewController.lessonname = self.lessonName
            }
        })
    }
}
