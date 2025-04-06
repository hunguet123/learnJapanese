//
//  SignInViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 22/7/24.
//

import UIKit
import SVProgressHUD

enum SignInTextFieldTag: Int {
    case emailAddress = 1
    case password = 2
}

class SignInViewController: BaseViewControler {
    @IBOutlet private weak var emailAddressTextField: TitleTextField!
    @IBOutlet private weak var passwordTextField: TitleTextField!
    @IBOutlet private weak var signInButton: DefaultButton!
    @IBOutlet private weak var forgotPasswordLabel: UILabel!
    
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
                                        .foregroundColor: AppColors.white,
        ], for: .normal)
        
        let underlineForgotPasswordAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineForgotPasswordAttributedString = NSAttributedString(string: LocalizationText.forgotPassword,
                                                                         attributes: underlineForgotPasswordAttribute)
        forgotPasswordLabel.attributedText = underlineForgotPasswordAttributedString
    }
    
    @IBAction func didTapSignIn(_ sender: Any) {
        SVProgressHUD.show()
        EmailPasswordSignInManager.shared.delegate = self
        if let email = emailAddressTextField.getText(), let password = passwordTextField.getText() {
            Task {
                await EmailPasswordSignInManager.shared.signIn(email, password, withPresenting: self)
            }
        }
    }
    
    @IBAction func didTapForgotPassword(_ sender: Any) {
        navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
    }
    
    @IBAction func didTapLoginWithGoogle(_ sender: Any) {
        SVProgressHUD.show()
        GoogleSignInManager.shared.delegate = self
        GoogleSignInManager.shared.signIn(withPresenting: self)
    }
    
    @IBAction func didTapLoginWithFacebook(_ sender: Any) {
        SVProgressHUD.show()
        FacebookSignInManager.shared.delegate = self
        FacebookSignInManager.shared.signIn(withPresenting: self)
    }
    
    @IBAction func didTapLoginWithApple(_ sender: Any) {
    }
}

extension SignInViewController: TitleTextFieldDelegate {
    func titleTextField(_ textField: UITextField, onChanged newText: String) {
        
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

extension SignInViewController: GoogleSignInManagerDelegate {
    func googleSignInManagerDidSignInFail(_ googleSignInManager: GoogleSignInManager) {
        SVProgressHUD.dismiss()
    }
    
    func googleSignInManagerDidSignInSuccessfully(_ googleSignInManager: GoogleSignInManager) {
        SVProgressHUD.dismiss()
        navigationController?.popAndPush(viewController: LevelSelectionViewController(), animated: true)
    }
}

extension SignInViewController: FacebookSignInDelegate {
    func facebookSignInManagerDidSignInFail(_ facebookSignInManager: FacebookSignInManager) {
        SVProgressHUD.dismiss()
    }
    
    func facebookSignInManagerDidSignInSuccessfully(_ facebookSignInManager: FacebookSignInManager) {
        SVProgressHUD.dismiss()
        navigationController?.popAndPush(viewController: LevelSelectionViewController(), animated: true)
    }
}

extension SignInViewController: EmailPasswordSignInDelegate {
    func emailPasswordSignInManagerDidSignInFail(_ emailPasswordSignInManager: EmailPasswordSignInManager) {
        SVProgressHUD.dismiss()
    }
    
    func emailPasswordSignInManagerDidSignInSuccessfully(_ emailPasswordSignInManager: EmailPasswordSignInManager) {
        SVProgressHUD.dismiss()
        navigationController?.popAndPush(viewController: LevelSelectionViewController(), animated: true)
    }
}
