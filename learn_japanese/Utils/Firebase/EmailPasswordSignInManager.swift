//
//  EmailPasswordSignInManager.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 28/7/24.
//

import UIKit
import FirebaseAuth

protocol EmailPasswordSignInDelegate: AnyObject {
    func emailPasswordSignInManagerDidSignInSuccessfully(_ emailPasswordSignInManager: EmailPasswordSignInManager)
    func emailPasswordSignInManagerDidSignInFail(_ emailPasswordSignInManager: EmailPasswordSignInManager)
}

class EmailPasswordSignInManager {
    static var shared = EmailPasswordSignInManager()
    weak var delegate: EmailPasswordSignInDelegate?
    
    func signIn(_ email: String , _ password: String, withPresenting viewController: UIViewController) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                let alertController = UIAlertController(title: LocalizationText.loginError, message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                viewController.present(alertController, animated: true, completion: nil)
                self.delegate?.emailPasswordSignInManagerDidSignInFail(self)
                return
            }
            
            UserManager.shared.fetchUserData { isSuccess in
                if isSuccess {
                    UserManager.shared.saveUserByFirebaseAuth()
                    self.delegate?.emailPasswordSignInManagerDidSignInSuccessfully(self)
                }
            }
        }
    }
}
