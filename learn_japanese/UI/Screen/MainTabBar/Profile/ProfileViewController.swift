//
//  ProfileViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 30/10/24.
//

import Foundation

class ProfileViewController: BaseViewControler {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    private var userModel: UserModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        guard let userModel = UserManager.shared.getUser() else {
            return
        }
        self.userModel = userModel
        userNameLabel.text = userModel.nickname
        avatarImageView.image = UIImage(named: userModel.avatarName)
    }

    @IBAction func didTapLogout(_ sender: Any) {
        if UserManager.shared.signOut() {
            navigationController?.popAndPush(viewController: LoginViewController(), animated: true)
        }
    }
    
    @IBAction func didTapChangeAvatar(_ sender: UIView) {
        if let avatarName = userModel?.avatarName {
            let avatarPickerVC = AvatarPickerViewController(delegate: self, selectedAvatar: avatarName)
            present(avatarPickerVC, animated: true, completion: nil)
        }
    }
    
}

// MARK: - AvatarPickerDelegate
extension ProfileViewController: AvatarPickerDelegate {
    func didSelectAvatar(_ avatarName: String) {
        avatarImageView.image = UIImage(named: avatarName)
        UserManager.shared.setAvatarName(avatarName: avatarName)
        UserManager.shared.saveUserByFirebaseAuth()
    }
}
