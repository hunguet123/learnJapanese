//
//  GoogleSignInManager.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 27/7/24.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

protocol GoogleSignInManagerDelegate: AnyObject {
    func googleSignInManagerDidSignInSuccessfully(_ googleSignInManager: GoogleSignInManager)
}

class GoogleSignInManager {
    static var shared = GoogleSignInManager()
    weak var delegate: GoogleSignInManagerDelegate?
    
    func signIn(withPresenting viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            guard error == nil else {
                print("failed to sign in with error \(error?.localizedDescription)")
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                print("failed to get idToken")
                return
            }
            
            print("accessToken: \(user.accessToken.tokenString)")
            
            let credential = GoogleAuthProvider
                .credential(withIDToken: idToken,
                            accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    viewController.present(alertController, animated: true, completion: nil)
                    return
                }
                
                UserManager.shared.saveUserByFirebaseAuth()
                if let self = self {
                    self.delegate?.googleSignInManagerDidSignInSuccessfully(self)
                }

            }
        }
    }
}
