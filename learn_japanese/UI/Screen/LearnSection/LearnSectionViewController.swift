//
//  LearnSectionViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 8/8/24.
//

import UIKit

class LearnSectionViewController: UIViewController {
    @IBOutlet weak var learningProgressView: UIProgressView!
    @IBOutlet weak var quizCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.quizCollectionView.register(UINib(nibName: "ImageTextQuestionCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImageTextQuestionCollectionViewCell")
    }

    @IBAction func didTapCloseLearnSection(_ sender: Any) {
        let confirmDialog = ConfirmDialog.loadView()
        confirmDialog.loadContent(type: .quitLearn)
        confirmDialog.delegate = self
        confirmDialog.show(in: self.view)
    }
}
