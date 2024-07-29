//
//  FacebookSignInManager.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 27/7/24.
//

import Foundation
import UIKit
import FacebookLogin
import FirebaseAuth

protocol FacebookSignInDelegate: AnyObject {
    func facebookSignInManagerDidSignInSuccessfully(_ facebookSignInManager: FacebookSignInManager)
    func facebookSignInManagerDidSignInFail(_ facebookSignInManager: FacebookSignInManager)
}

class FacebookSignInManager {
    static var shared = FacebookSignInManager()
    weak var delegate: FacebookSignInDelegate?

    func signIn(withPresenting viewController: UIViewController) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { [weak self] (result, error) in
            guard let self = self else {
                return
            }
            
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                self.delegate?.facebookSignInManagerDidSignInFail(self)
                return
            }
            
            if result?.isCancelled == true {
                print("cancelled login facebook")
                self.delegate?.facebookSignInManagerDidSignInFail(self)
                return
            }

            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                self.delegate?.facebookSignInManagerDidSignInFail(self)
                return
            }

            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)

            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { [weak self] (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: LocalizationText.loginError, message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    viewController.present(alertController, animated: true, completion: nil)
                    if let self = self {
                        self.delegate?.facebookSignInManagerDidSignInFail(self)
                        return
                    }
                }
                                
                UserManager.shared.saveUserByFirebaseAuth()
                if let self = self {
                    self.delegate?.facebookSignInManagerDidSignInSuccessfully(self)
                }
            })

        }
    }

}

