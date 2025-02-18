//
//  LearnResultViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 18/2/25.
//

import UIKit

class LearnResultViewController: UIViewController {
    @IBOutlet weak var titleResult: UILabel!
    
    var learnResultViewModel: LearnResultViewModel?
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var wrongAnswerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        correctAnswerLabel.text = "\(learnResultViewModel?.correctAnswer ?? 0)"
        wrongAnswerLabel.text = "\(learnResultViewModel?.wrongAnswer ?? 0)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = self.view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.view.bounds
        }
    }
    
    private func setUpView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [
            AppColors.lavenderIndigo?.cgColor ?? UIColor.white.cgColor,
            AppColors.lightDeepPink?.cgColor ?? UIColor.white.cgColor,
        ]
        
        gradientLayer.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func didTapCloseButton(_ sender: TapableView) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: false)
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapTryAgain(_ sender: TapableView) {
        navigationController?.popViewController(animated: true)
        if let learnSectionViewController = navigationController?.topViewController as? LearnSectionViewController {
            learnSectionViewController.resetProgress()
        }
    }
    
}
