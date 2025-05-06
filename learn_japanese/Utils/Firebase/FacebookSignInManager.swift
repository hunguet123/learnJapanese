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
        
        // Đảm bảo clear token trước đó
        loginManager.logOut()
        
        loginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { [weak self] (result, error) in
            guard let self = self else { return }
            
            // Xử lý các trường hợp khi quay lại từ Facebook
            if let token = AccessToken.current {
                // Đã có token, tiến hành xác thực
                self.handleFacebookLoginSuccess(token: token, viewController: viewController)
            } else if let error = error {
                // Xử lý lỗi
                print("Facebook Login Error: \(error.localizedDescription)")
                self.handleLoginFailure(in: viewController)
            } else {
                // Trường hợp khác
                print("Facebook Login: Unexpected state")
                self.handleLoginFailure(in: viewController)
            }
        }
    }
    
    private func handleFacebookLoginSuccess(token: AccessToken, viewController: UIViewController) {
        // Thực hiện đăng nhập Firebase
        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Firebase Login Error: \(error.localizedDescription)")
                self.handleLoginFailure(in: viewController, message: error.localizedDescription)
                return
            }
            
            // Fetch và lưu thông tin người dùng
            self.fetchAndSaveUserData(viewController: viewController)
        }
    }
    
    private func fetchAndSaveUserData(viewController: UIViewController) {
        UserManager.shared.fetchUserData { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                UserManager.shared.saveUserByFirebaseAuth()
                self.delegate?.facebookSignInManagerDidSignInSuccessfully(self)
            } else {
                self.handleLoginFailure(in: viewController)
            }
        }
    }
    
    private func handleLoginFailure(in viewController: UIViewController, message: String? = nil) {
        // Hiển thị thông báo lỗi
        let alertController = UIAlertController(
            title: "Đăng Nhập Thất Bại",
            message: message ?? "Không thể đăng nhập bằng Facebook. Vui lòng thử lại.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
        
        // Gọi delegate fail
        self.delegate?.facebookSignInManagerDidSignInFail(self)
    }
}

