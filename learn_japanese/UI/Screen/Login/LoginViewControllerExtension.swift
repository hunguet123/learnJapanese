//
//  LoginViewControllerExtension.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 17/7/24.
//

import UIKit

extension LoginViewController: DefaultTabBarViewDelegate, TitleTextFieldDelegate {
    func titleTextField(_ textField: UITextField, onChanged newText: String) {
        print("---- \(newText)")
    }
    
    func tabBar(_ tabBar: DefaultTabBarView, didSelectItemAt index: Int) {
        
    }
}
