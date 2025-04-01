//
//  ProfileViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 30/10/24.
//

import Foundation

class ProfileViewController: BaseViewControler {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func didTapLogout(_ sender: Any) {
        if UserManager.shared.signOut() {

            navigationController?.popAndPush(viewController: LoginViewController(), animated: true)
        }
    }
}
