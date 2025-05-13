//
//  SplashViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 15/7/24.
//

import UIKit
import Lottie

class SplashViewController: BaseViewControler {
    @IBOutlet weak var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.animation = LottieAnimation.named(AppLotties.lauch)
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 0.5
        animationView.contentMode = .scaleAspectFill
        UserManager.shared.fetchUserData { isSuccess in
            if !isSuccess {
                self.navigationController?.popAndPush(viewController: LoginViewController(), animated: true)
                return
            }
            
            UserProgressManager.shared.fetchUserProgress { result in
                self.animationView.play { [weak self] _ in
                    guard let self = self else {
                        return
                    }
                    
                    if UserManager.shared.isLoginBefore() {
                        if let currentLevelFromUserProgress = UserProgressManager.shared.userProgressModel?.currentLevel {
                            let levelSelected = JapaneseLevel.from(string: currentLevelFromUserProgress)
                            
                            let homeViewModel = HomeViewModel(japaneseLevel: levelSelected)
                            let homeController = HomeViewController()
                            homeController.homeViewModel = homeViewModel
                            UserProgressManager.shared.updateCurrentLevel(japaneseLevel: levelSelected)
                            navigationController?.popAndPush(viewController: homeController, animated: true)
                            
                            return
                        }
                        
                        navigationController?.popAndPush(viewController: LevelSelectionViewController(), animated: true)
                    } else {
                        navigationController?.popAndPush(viewController: LoginViewController(), animated: true)
                    }
                }
            }
        }
    }
}
