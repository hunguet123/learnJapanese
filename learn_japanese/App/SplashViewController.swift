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
        animationView.play { _ in
            self.navigationController?.popAndPush(viewController: LoginViewController(), animated: true)
        }
    }
}
