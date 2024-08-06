//
//  LearnViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 5/8/24.
//

import UIKit

class LearnViewController: BaseViewControler {
    @IBOutlet weak var titleLabel: UILabel!
    var lessonId: String?
    var lessonname: String?
    var learnViewModel: LearnViewModel?
    @IBOutlet weak var lessonsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupUI()
    }
    
    private func setupUI() {
        if let lessonname = self.lessonname, let lessonCount = self.learnViewModel?.sections?.count {
            titleLabel.text = "\(lessonname) \(lessonCount) \(LocalizationText.lesson)"
        }
        lessonsCollectionView.delegate = self
        lessonsCollectionView.dataSource = self
    }
    
    private func fetchData() {
        if let lessonId = self.lessonId {
            learnViewModel?.fetchData(lessonId: lessonId)
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func didTapProfile(_ sender: Any) {
        // TODO: didTapProfile
    }
}
