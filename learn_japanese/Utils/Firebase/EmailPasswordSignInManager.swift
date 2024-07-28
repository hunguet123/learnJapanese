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
}

class EmailPasswordSignInManager {
    static var shared = EmailPasswordSignInManager()
    weak var delegate: EmailPasswordSignInDelegate?
    
    func signIn(_ email: String , _ password: String, withPresenting viewController: UIViewController) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                viewController.present(alertController, animated: true, completion: nil)
                return
            }
            
            print("Login successfully!")
            UserManager.shared.saveUserByFirebaseAuth()
            if let self = self {
                self.delegate?.emailPasswordSignInManagerDidSignInSuccessfully(self)
            }
        }
    }
}
