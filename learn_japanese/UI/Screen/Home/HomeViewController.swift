//
//  HomeViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 3/8/24.
//

import UIKit

class HomeViewController: BaseViewControler {
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lesssonsCollectionView: UICollectionView!
    
    var homeViewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGradientLayer()
        fetchData()
        setupUI()
    }


    private func setupUI() {
        levelLabel.text = homeViewModel?.japaneseLevel.value
        lesssonsCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }
    
    private func fetchData() {
        self.homeViewModel?.fetchLesssons()
    }
    
    private func setUpGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            AppColors.lavenderIndigo?.cgColor,
            AppColors.lightDeepPink?.cgColor
        ]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    @IBAction func didTapNavigateToLevelScreen(_ sender: UIButton) {
        let levelSelectionViewController = LevelSelectionViewController()
        navigationController?.pushViewController(levelSelectionViewController, animated: true)
        levelSelectionViewController.levelSelected = homeViewModel?.japaneseLevel
    }
    @IBAction func didTapNavigateToUserScreen(_ sender: Any) {
    }
}
