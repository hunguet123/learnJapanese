//
//  ProfileViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 30/10/24.
//

import UIKit

class ProfileViewController: BaseViewControler {
    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - Private Properties
    private var userModel: UserModel?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setData()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        // Styling avatar
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true
    }
    private func setData() {
        guard let userModel = UserManager.shared.getUser() else {
            return
        }
        
        self.userModel = userModel
        emailLabel.text = userModel.email
        avatarImageView.image = UIImage(named: userModel.avatarName)
        
    }
    
    // MARK: - IBActions
    @IBAction func didTapLogout(_ sender: Any) {
        showLogoutConfirmation()
    }
    
    @IBAction func didTapChangeAvatar(_ sender: UIView) {
        if let avatarName = userModel?.avatarName {
            let avatarPickerVC = AvatarPickerViewController(delegate: self, selectedAvatar: avatarName)
            present(avatarPickerVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Profile Management Methods
    private func showLogoutConfirmation() {
        let alertController = UIAlertController(
            title: LocalizationText.logout,
            message: LocalizationText.doYouWantLogout,
            preferredStyle: .alert
        )
        
        let logoutAction = UIAlertAction(title: LocalizationText.logout, style: .destructive) { [weak self] _ in
            self?.performLogout()
        }
        
        let cancelAction = UIAlertAction(title: LocalizationText.cancel, style: .cancel)
        
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func performLogout() {
        if UserManager.shared.signOut() {
            navigationController?.popAndPush(viewController: LoginViewController(), animated: true)
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
