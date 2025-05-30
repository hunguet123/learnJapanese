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
    
    var title: String {
        switch self {
        case .start:
            return LocalizationText.startJapanese
        case .basic:
            return LocalizationText.basicJapanese
        case .intermediate:
            return LocalizationText.intermediateJapanese
        }
    }
    
    var level: LessonLevel {
        switch self {
        case .start:
            return .N5
        case .basic:
            return .N4
        case .intermediate:
            return .N3
        }
    }
    
    static func from(string: String) -> JapaneseLevel {
        switch string {
        case "N5":
            return .start
        case "N4":
            return .basic
        case "N3":
            return .intermediate
        default:
            return .start
        }
    }
}

class LevelSelectionViewController: BaseViewControler {
    @IBOutlet var levelButtons: [TapableView]!
    @IBOutlet weak var scrollView: UIScrollView!
    var levelSelected : JapaneseLevel = .start {
        didSet {
            handleSelectLevel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        updateUserProgress()
    }
    
    private func updateUserProgress() {
        guard let firstLessonModel = LessonServiceUtils.getLessons(byLevel: levelSelected.level.rawValue).first else {
            return
        }
        
        let excercises: [ExerciseModel] = ExerciseServiceUtils.getExercises(byLessonId: firstLessonModel.lessonId)
        
        UserProgressManager.shared.addLessonProgress(lessonId: firstLessonModel.lessonId, totalExercises: excercises.count, isAccessible: true) { result in
            print("------ firebase Result \(result)")
        }
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
        let homeViewModel = HomeViewModel(japaneseLevel: levelSelected)
        let homeController = HomeViewController()
        homeController.homeViewModel = homeViewModel
        UserProgressManager.shared.fetchUserProgress { _ in
            UserProgressManager.shared.updateCurrentLevel(japaneseLevel: self.levelSelected)
            self.navigationController?.popAndPush(viewController: homeController, animated: true)
        }
    }
}
