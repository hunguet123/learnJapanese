//
//  DictionaryViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 1/10/24.
//

import Foundation
import UIKit

class DictionaryViewController: BaseViewControler {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tabBarStackView: UIStackView!
    
    private let tabButtons = ["Tab 1", "Tab 2", "Tab 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTabBar()
    }
    
    private func setupUI() {
        titleLabel.text = LocalizationText.dictionary
    }
    
    private func setupTabBar() {
        for (index, title) in tabButtons.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            
            tabBarStackView.addArrangedSubview(button)
        }
    }
    
    @objc func tabButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        print("Tab \(index + 1) selected")
        
    }
}
