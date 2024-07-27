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
}

class FacebookSignInManager {
    static var shared = FacebookSignInManager()
    weak var delegate: FacebookSignInDelegate?

    func signIn(withPresenting viewController: UIViewController) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }

            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }

            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)

            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    viewController.present(alertController, animated: true, completion: nil)
                    return
                } else {
                    UserManager.shared.saveUserByFirebaseAuth()
                    self.delegate?.facebookSignInManagerDidSignInSuccessfully(self)
                }

            })

        }
    }

}

