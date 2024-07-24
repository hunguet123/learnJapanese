//
//  SignUpViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 22/7/24.
//

import UIKit

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
        passwordTextField.setTag(SignUpTextFieldTag.password.rawValue)
        passwordTextField.delegate = self
    }
    
    private func updateRequirementPassword(password: String) {
        if Validation.hasMinimumLength(password) {
            passwordRequiredImage[0].image = AppImages.iconCheckmarkCircle
        } else {
            passwordRequiredImage[0].image = AppImages.iconUnCheckMarkCircle
        }
        
        if Validation.hasUppercaseCharacter(password) {
            passwordRequiredImage[1].image = AppImages.iconCheckmarkCircle
        } else {
            passwordRequiredImage[1].image = AppImages.iconUnCheckMarkCircle
        }
        
        if Validation.hasSpecialCharacter(password) {
            passwordRequiredImage[2].image = AppImages.iconCheckmarkCircle
        } else {
            passwordRequiredImage[2].image = AppImages.iconUnCheckMarkCircle
        }
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
    }
}

extension SignUpViewController: TitleTextFieldDelegate {
    func titleTextField(_ textField: UITextField, onChanged newText: String) {
        if (textField.tag == SignUpTextFieldTag.userName.rawValue) {
            // TODO: validate user name
        } else if (textField.tag == SignUpTextFieldTag.emailAddress.rawValue) {
            // TODO: validate email
        } else if (textField.tag == SignUpTextFieldTag.password.rawValue) {            updateRequirementPassword(password: newText)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == SignUpTextFieldTag.userName.rawValue) {
            emailAddressTextField.textFieldBecomFirstResponder()
        } else if (textField.tag == SignUpTextFieldTag.emailAddress.rawValue) {
            passwordTextField.textFieldBecomFirstResponder()
        } else if (textField.tag == SignUpTextFieldTag.password.rawValue) {
            passwordTextField.textFieldResignFirstResponder()
        }
        return true
    }
}
