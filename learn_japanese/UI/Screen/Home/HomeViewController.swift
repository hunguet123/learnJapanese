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
    private var indicator: UIActivityIndicatorView = {
         let activityIndicator = UIActivityIndicatorView(style: .large)
         return activityIndicator
     }()
    
    var homeViewModel: HomeViewModel?
    internal var indexCurrentLessonModel: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
        guard let avatarName = UserManager.shared.getUser()?.avatarName else {
            return
        }
        
        userImage.image = UIImage(named: avatarName)
    }
    
    override func viewDidLayoutSubviews() {
        setUpGradientLayer()
    }

    private func setupUI() {
        self.indicator.fixInView(self.view)
        indicator.isHidden = false
        levelLabel.text = homeViewModel?.japaneseLevel.title
        lesssonsCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }
    
    private func fetchData() {
        self.homeViewModel?.onChangeApiStatus = { [weak self] apiStatus in
            switch apiStatus {
            case .success:
                self?.lesssonsCollectionView.reloadData()
                self?.indicator.stopAnimating()
                self?.indicator.isHidden = true
            case .loading:
                self?.indicator.startAnimating()
                self?.indicator.isHidden = false
            case .failure:
                self?.indicator.stopAnimating()
                self?.indicator.isHidden = true
            default:
                break
            }
        }
        self.homeViewModel?.fetchLesssons()
    }
    
    private func setUpGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            AppColors.buttonEnable.cgColor,
            AppColors.lightDeepPink?.cgColor ?? UIColor.clear.cgColor,
        ]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    @IBAction func didTapNavigateToLevelScreen(_ sender: UIButton) {
        let levelSelectionViewController = LevelSelectionViewController()
        navigationController?.pushViewController(levelSelectionViewController, animated: true)
        levelSelectionViewController.levelSelected = homeViewModel?.japaneseLevel ?? .start
    }
    @IBAction func didTapNavigateToUserScreen(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarViewController
        guard let lessonModel = self.homeViewModel?.lessonDTOs[self.indexCurrentLessonModel].lesssonModel else {
            return
        }
        
        tabBarController.lessonId = lessonModel.lessonId
        tabBarController.lessonName = lessonModel.title
        tabBarController.selectedIndex = 2
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
}
