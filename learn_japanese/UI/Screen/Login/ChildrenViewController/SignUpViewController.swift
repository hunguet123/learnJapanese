//
//  SignUpViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 22/7/24.
//

import UIKit
import SVProgressHUD

enum SignUpTextFieldTag: Int {
    case userName = 1
    case emailAddress = 2
    case password = 3
}

class SignUpViewController: BaseViewControler {
    @IBOutlet private weak var userNameTextField: TitleTextField!
    @IBOutlet private weak var emailAddressTextField: TitleTextField!
    @IBOutlet private weak var passwordTextField: TitleTextField!
    @IBOutlet var passwordRequiredImage: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        userNameTextField.setTitle(LocalizationText.userName)
        userNameTextField.setHintText(LocalizationText.userName)
        userNameTextField.setKeyboardType(.default)
        userNameTextField.setContentType(.username)
        userNameTextField.setTag(SignUpTextFieldTag.userName.rawValue)
        userNameTextField.delegate = self
        
        emailAddressTextField.setTitle(LocalizationText.emailAddress)
        emailAddressTextField.setHintText(LocalizationText.emailAddress)
        emailAddressTextField.setKeyboardType(.emailAddress)
        emailAddressTextField.setContentType(.emailAddress)
        emailAddressTextField.setTag(SignUpTextFieldTag.emailAddress.rawValue)
        emailAddressTextField.delegate = self
        
        passwordTextField.setTitle(LocalizationText.password)
        passwordTextField.setHintText(LocalizationText.password)
        passwordTextField.setContentType(.password)
        passwordTextField.setReturnKeyType(.done)
        passwordTextField.setSecureText(true)
        passwordTextField.setTag(SignUpTextFieldTag.password.rawValue)
        passwordTextField.delegate = self
    }
    
    private func updateRequirementPassword(password: String) {
        if Validation.hasMinimumLength(password) {
            passwordRequiredImage[2].image = AppImages.iconCheckmarkCircle
        } else {
            passwordRequiredImage[2].image = AppImages.iconUnCheckMarkCircle
        }
        
        if Validation.hasUppercaseCharacter(password) {
            passwordRequiredImage[1].image = AppImages.iconCheckmarkCircle
        } else {
            passwordRequiredImage[1].image = AppImages.iconUnCheckMarkCircle
        }
        
        if Validation.hasSpecialCharacter(password) {
            passwordRequiredImage[0].image = AppImages.iconCheckmarkCircle
        } else {
            passwordRequiredImage[0].image = AppImages.iconUnCheckMarkCircle
        }
    }
    
    private func checkValidateSignUp() -> Bool {
        let password = passwordTextField.getText() ?? ""
        let email = emailAddressTextField.getText() ?? ""
        let userName = userNameTextField.getText() ?? ""
        return Validation.hasMinimumLength(password)
        && Validation.hasUppercaseCharacter(password)
        && Validation.hasSpecialCharacter(password)
        && Validation.isValidEmail(email)
        && userName.count > Constant.maxLengthUserName
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        if checkValidateSignUp() == true {
            SVProgressHUD.show()
            let password = passwordTextField.getText() ?? ""
            let email = emailAddressTextField.getText() ?? ""
            let userName = userNameTextField.getText() ?? ""
            SignUpManager.shared.delegate = self
            Task {
                SignUpManager.shared.signUp(email,
                                            password,
                                            userName,
                                            withPresenting: self)
            }
        }
    }
}

extension SignUpViewController: TitleTextFieldDelegate {
    func titleTextField(_ textField: UITextField, onChanged newText: String) {
        if (textField.tag == SignUpTextFieldTag.userName.rawValue) {
            // TODO: validate user name
        } else if (textField.tag == SignUpTextFieldTag.emailAddress.rawValue) {
            // TODO: validate email
        } else if (textField.tag == SignUpTextFieldTag.password.rawValue) {
            updateRequirementPassword(password: newText)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == SignUpTextFieldTag.userName.rawValue) {
            emailAddressTextField.textFieldBecomFirstResponder()
        } else if (textField.tag == SignUpTextFieldTag.emailAddress.rawValue) {
            passwordTextField.textFieldBecomFirstResponder()
        }
        return true
    }
}

extension SignUpViewController: SignUpDelegate {
    func signUpManagerDidSignUpSuccessfully(_ signUpManage: SignUpManager) {
        SVProgressHUD.dismiss()
        navigationController?.popAndPush(viewController: LevelSelectionViewController(), animated: true)
    }
    
    func signUpManagerDidSignUpFaild(_ signUpManage: SignUpManager) {
        SVProgressHUD.dismiss()
    }
}
