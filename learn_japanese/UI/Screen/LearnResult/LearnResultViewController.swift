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
        displayResult()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = self.view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.view.bounds
        }
    }
    
    private func displayResult() {
        guard let correctAnswer = learnResultViewModel?.correctAnswer else {
            return
        }
        
        guard let wrongAnswer = learnResultViewModel?.wrongAnswer else {
            return
        }
        
        correctAnswerLabel.text = "\(correctAnswer)"
        wrongAnswerLabel.text = "\(wrongAnswer)"
        
        let scorePercentage = (Double(correctAnswer) / Double(correctAnswer + wrongAnswer)) * 100
        switch scorePercentage {
        case 0...50:
            titleResult.text = LocalizationText.needImprovement
        case 51...75:
            titleResult.text = LocalizationText.fair
        case 76...90:
            titleResult.text = LocalizationText.good
        case 91...100:
            titleResult.text = LocalizationText.excellent
        default:
            titleResult.text = ""
        }
    }
    
    private func setUpView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [
            AppColors.buttonEnable.cgColor,
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
