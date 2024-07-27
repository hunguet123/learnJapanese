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
            
            Auth.auth().signIn(with: credential) { result, error in
                if error == nil {
                    print("Sign in successfully!")
                    UserManager.shared.saveUserByFirebaseAuth()
                    self.delegate?.googleSignInManagerDidSignInSuccessfully(self)
                } else {
                    print("Sign in failed with error \(error!.localizedDescription)")
                }
            }
        }
    }
}
