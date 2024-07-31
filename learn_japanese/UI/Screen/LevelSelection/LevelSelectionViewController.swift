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
}

class LevelSelectionViewController: BaseViewControler {
    @IBOutlet var levelButtons: [TapableView]!
    
    private var levelSelected : JapaneseLevel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    private func setupUi() {
        levelButtons.forEach { button in
            button.addTarget(self, action: #selector(didTapSelectLevel(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func didTapSelectLevel(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            levelButtons[0].backgroundColor = AppColors.goldenPoppy
            levelButtons[1].backgroundColor = AppColors.jasmine
            levelButtons[2].backgroundColor = AppColors.jasmine
            levelSelected = .start
        case 1:
            levelButtons[0].backgroundColor = AppColors.jasmine
            levelButtons[1].backgroundColor = AppColors.goldenPoppy
            levelButtons[2].backgroundColor = AppColors.jasmine
            levelSelected = .basic
        case 2:
            levelButtons[0].backgroundColor = AppColors.jasmine
            levelButtons[1].backgroundColor = AppColors.jasmine
            levelButtons[2].backgroundColor = AppColors.goldenPoppy
            levelSelected = .intermediate
        default: break
        }
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        if let levelSelected = levelSelected {
            // TODO: next screen
        }
    }
    
}
