//
//  ForgotPasswordManager.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 29/7/24.
//

import FirebaseAuth

protocol ForgotPasswordDelegate: AnyObject {
    func forgotPasswordManagerDidSuccessfully(_ forgotPasswordManager: ForgotPasswordManager)
    func forgotPasswordManagerDidFail(_ forgotPasswordManager: ForgotPasswordManager)
}

class ForgotPasswordManager {
    static var shared = ForgotPasswordManager()
    weak var delegate: ForgotPasswordDelegate?
    
    
    func sendPasswordReset(withEmail email: String, _ viewController: UIViewController){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                let alertController = UIAlertController(title: LocalizationText.sendMailError, message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                viewController.present(alertController, animated: true, completion: nil)
                self.delegate?.forgotPasswordManagerDidFail(self)
                return
            }
        }
    }
}
