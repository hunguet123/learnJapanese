//
//  DefaultButton.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 17/7/24.
//

import UIKit

class DefaultButton: TapableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = AppColors.buttonEnable
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.backgroundColor = color
    }
    
    func setTextAttributes(_ attributes: [NSAttributedString.Key: Any], for state: UIControl.State) {
        guard let title = self.title(for: state) else { return }
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        self.setAttributedTitle(attributedTitle, for: state)
    }

}
