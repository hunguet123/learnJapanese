//
//  LevelSelectionViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 25/7/24.
//

import UIKit

enum JapaneseLevel {
    case start
    case basic
    case intermediate
    
    var value: String {
        switch self {
        case .start:
            return LocalizationText.startJapanese
        case .basic:
            return LocalizationText.basicJapanese
        case .intermediate:
            return LocalizationText.intermediateJapanese
        }
    }
}

class LevelSelectionViewController: BaseViewControler {
    @IBOutlet var levelButtons: [TapableView]!
    @IBOutlet weak var scrollView: UIScrollView!
    var levelSelected : JapaneseLevel? {
        didSet {
            handleSelectLevel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    private func setupUi() {
        levelButtons.forEach { button in
            button.addTarget(self, action: #selector(didTapSelectLevel(_:)), for: .touchUpInside)
        }
        scrollView.contentInsetAdjustmentBehavior = .never
        handleSelectLevel()
    }
    
    private func handleSelectLevel() {
        guard let levelButtons = self.levelButtons else {
            return
        }
        
        switch self.levelSelected {
        case .start:
            levelButtons[0].backgroundColor = AppColors.goldenPoppy
            levelButtons[1].backgroundColor = AppColors.jasmine
            levelButtons[2].backgroundColor = AppColors.jasmine
        case .basic:
            levelButtons[0].backgroundColor = AppColors.jasmine
            levelButtons[1].backgroundColor = AppColors.goldenPoppy
            levelButtons[2].backgroundColor = AppColors.jasmine
        case .intermediate:
            levelButtons[0].backgroundColor = AppColors.jasmine
            levelButtons[1].backgroundColor = AppColors.jasmine
            levelButtons[2].backgroundColor = AppColors.goldenPoppy
        default: break
        }
    }
    
    @objc private func didTapSelectLevel(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            levelSelected = .start
        case 1:
            levelSelected = .basic
        case 2:
            levelSelected = .intermediate
        default: break
        }
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        if let levelSelected = levelSelected {
            let homeViewModel = HomeViewModel(japaneseLevel: levelSelected)
            let homeController = HomeViewController()
            homeController.homeViewModel = homeViewModel
            navigationController?.popAndPush(viewController: homeController, animated: true)
        }
    }
    
}
