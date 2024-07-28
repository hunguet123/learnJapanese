//
//  LevelSelectionViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 25/7/24.
//

import UIKit

class LevelSelectionViewController: BaseViewControler {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func didTapSignOut(_ sender: UIButton) {
        if UserManager.shared.signOut() {
            navigationController?.popAndPush(viewController: LoginViewController(), animated: true)
        }
    }
}
