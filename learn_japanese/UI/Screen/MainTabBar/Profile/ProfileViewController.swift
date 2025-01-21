//
//  ProfileViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 30/10/24.
//

import Foundation
import SVGKit

class ProfileViewController: BaseViewControler {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let filePath = Bundle.main.path(forResource: "あ", ofType: "svg") {
            let fileURL = URL(fileURLWithPath: filePath)
             
             // Tạo đối tượng SVGKImage từ tệp SVG
             if let svgImage = SVGKImage(contentsOf: fileURL) {
                 let svgView = SVGKFastImageView(svgkImage: svgImage)!
                 svgView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
                 self.view.addSubview(svgView)
             }
        }
    }
    

    @IBAction func didTapLogout(_ sender: Any) {
        if UserManager.shared.signOut() {

            navigationController?.popAndPush(viewController: LoginViewController(), animated: true)
        }
    }
}
