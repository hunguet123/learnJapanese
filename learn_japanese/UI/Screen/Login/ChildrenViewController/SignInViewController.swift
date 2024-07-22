//
//  SignInViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 22/7/24.
//

import UIKit

enum SignInTextFieldTag: Int {
    case emailAddress = 1
    case password = 2
}

class SignInViewController: BaseViewControler {
    @IBOutlet weak var emailAddressTextField: TitleTextField!
    @IBOutlet weak var passwordTextField: TitleTextField!
    @IBOutlet weak var signInButton: DefaultButton!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        emailAddressTextField.setTitle(LocalizationText.emailAddress)
        emailAddressTextField.setHintText(LocalizationText.emailAddress)
        emailAddressTextField.setKeyboardType(.emailAddress)
        emailAddressTextField.setContentType(.emailAddress)
        emailAddressTextField.setTag(SignInTextFieldTag.emailAddress.rawValue)
        emailAddressTextField.delegate = self
        
        passwordTextField.setTitle(LocalizationText.password)
        passwordTextField.setHintText(LocalizationText.password)
        passwordTextField.setContentType(.password)
        passwordTextField.setReturnKeyType(.done)
        passwordTextField.setSecureText(true)
        passwordTextField.setTag(SignInTextFieldTag.password.rawValue)
        passwordTextField.delegate = self
        
        signInButton.setTitle(LocalizationText.login, for: .normal)
        signInButton.setTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .bold),
                                        .foregroundColor: AppColor.white,
        ], for: .normal)
        
        let underlineForgotPasswordAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineForgotPasswordAttributedString = NSAttributedString(string: LocalizationText.forgotPassword,
                                                                         attributes: underlineForgotPasswordAttribute)
        forgotPasswordLabel.attributedText = underlineForgotPasswordAttributedString
    }
    @IBAction func tapToSignIn(_ sender: Any) {
        
    }
}

extension SignInViewController: TitleTextFieldDelegate {
    func titleTextField(_ textField: UITextField, onChanged newText: String) {
        print("----- newText\(newText)")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == SignInTextFieldTag.emailAddress.rawValue) {
            passwordTextField.textFieldBecomFirstResponder()
        } else if (textField.tag == SignInTextFieldTag.password.rawValue) {
            passwordTextField.textFieldResignFirstResponder()
        }
        return true
    }
}
