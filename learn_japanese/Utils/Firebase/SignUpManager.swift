//
//  SignUpManager.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 29/7/24.
//

import Foundation
import UIKit
import FirebaseAuth

protocol SignUpDelegate: AnyObject{
    func signUpManagerDidSignUpSuccessfully(_ signUpManage: SignUpManager)
    func signUpManagerDidSignUpFaild(_ signUpManage: SignUpManager)
}

class SignUpManager {
    static var shared = SignUpManager()
    weak var delegate: SignUpDelegate?
    
    func signUp(_ email: String ,
                _ password: String,
                withPresenting viewController: UIViewController
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                let alertController = UIAlertController(title: LocalizationText.signUpError, message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                viewController.present(alertController, animated: true, completion: nil)
                self.delegate?.signUpManagerDidSignUpFaild(self)
                return
            }
            
            // TODO: save user to data base.
            UserManager.shared.saveUserByFirebaseAuth()
            self.delegate?.signUpManagerDidSignUpSuccessfully(self)
        }
    }
}
