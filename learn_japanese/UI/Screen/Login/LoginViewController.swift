//
//  LoginViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 15/7/24.
//

import UIKit
import L10n_swift

class LoginViewController: BaseViewControler{
    // MARK: outlet
    @IBOutlet weak var titleHeader: GradientTextLabel!
    @IBOutlet weak var tabBarView: DefaultTabBarView!
    
    // MARK: private variable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        titleHeader.setGradientColors([
            AppColor.pastelMagenta?.withAlphaComponent(0.8),
            AppColor.orchid,
            AppColor.lavenderIndigo,
        ])

        tabBarView.delegate = self
        tabBarView.items = [LocalizationText.login, LocalizationText.signUp]
        tabBarView.layer.shadowColor = UIColor.black.cgColor
        tabBarView.layer.shadowOpacity = 0.5
        tabBarView.layer.shadowRadius = 5
        tabBarView.layer.shadowOffset = CGSize(width: 2, height: 2)
        tabBarView.layer.shadowPath = UIBezierPath(roundedRect: tabBarView.bounds, cornerRadius: tabBarView.layer.cornerRadius).cgPath
        tabBarView.layer.masksToBounds = false
        
        tabBarView.shadowRadius = 5
    }
}


