//
//  ForgotPasswordViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 29/7/24.
//

import UIKit
import SVProgressHUD

class ForgotPasswordViewController: BaseViewControler {
    @IBOutlet weak var forgotPasswordTextField: TitleTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        forgotPasswordTextField.setContentType(.emailAddress)
        forgotPasswordTextField.setTitle(LocalizationText.emailAddress)
        forgotPasswordTextField.setHintText(LocalizationText.emailAddress)
    }
    @IBAction func didTapSendEmail(_ sender: Any) {
        SVProgressHUD.show()
        ForgotPasswordManager.shared.delegate = self
        if let email = forgotPasswordTextField.getText() {
            ForgotPasswordManager.shared.sendPasswordReset(withEmail: email, self)
        }
    }
}

extension ForgotPasswordViewController: ForgotPasswordDelegate {
    func forgotPasswordManagerDidSuccessfully(_ forgotPasswordManager: ForgotPasswordManager) {
        SVProgressHUD.dismiss()
        if let email = forgotPasswordTextField.getText() {
            let alertController = UIAlertController(title: LocalizationText.emailSentSuccessfully, message: "\(LocalizationText.sentEmail) \(email)", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .default) {_ in 
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func forgotPasswordManagerDidFail(_ forgotPasswordManager: ForgotPasswordManager) {
        SVProgressHUD.dismiss()
    }
}
