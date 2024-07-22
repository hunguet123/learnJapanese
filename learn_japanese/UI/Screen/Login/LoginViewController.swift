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
    @IBOutlet weak var tabViewScroll: UIScrollView!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var signUpView: UIView!
    
    // MARK: private variable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpChilrenViewController()
        setUpGesture()
    }
    
    private func setupUI() {
        titleHeader.setGradientColors([
            AppColor.pastelMagenta?.withAlphaComponent(0.8),
            AppColor.orchid,
            AppColor.lavenderIndigo,
        ])
        
        tabBarView.delegate = self
        tabBarView.items = [LocalizationText.login, LocalizationText.signUp]
    }
    
    private func setUpChilrenViewController() {
        let signInViewController = SignInViewController()
        let signUpViewController = SignUpViewController()
        addChild(signInViewController)
        signInViewController.view.fixInView(signInView)
        signInViewController.didMove(toParent: self)
        addChild(signUpViewController)
        signUpViewController.view.fixInView(signUpView)
        signUpViewController.didMove(toParent: self)
    }
    
    private func setUpGesture() {
        let tapHiddenKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapHiddenKeyboard)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}


