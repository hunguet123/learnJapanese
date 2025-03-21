//
//  LearnViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 5/8/24.
//

import UIKit

class LearnViewController: BaseViewControler {
    @IBOutlet weak var titleLabel: UILabel!
    var lessonId: Int?
    var lessonname: String?
    var learnViewModel: LearnViewModel?
    @IBOutlet weak var lessonsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        self.lessonsCollectionView.reloadData()
        if let lessonname = self.lessonname, let lessonCount = self.learnViewModel?.exerciseDTOs.count {
            titleLabel.text = "\(lessonname) \(lessonCount) \(LocalizationText.lesson)"
        }
    }
    
    private func setupUI() {
        lessonsCollectionView.delegate = self
        lessonsCollectionView.dataSource = self
    }
    
    private func fetchData() {
        if let lessonId = self.lessonId {
            learnViewModel?.fetchExercises(byLessonId: lessonId)
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func didTapPopViewController(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapProfile(_ sender: Any) {
        // TODO: didTapProfile
    }
}
