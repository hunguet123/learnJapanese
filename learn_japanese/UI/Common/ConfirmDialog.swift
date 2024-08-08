//
//  ConfirmDialog.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 8/8/24.
//

import UIKit

enum ConfirmDialogType {
    case quitLearn
}

protocol ConfirmDialogDelegate {
    func confirmDialogDidTapAccept(_ confirmDialog: ConfirmDialog)
}

class ConfirmDialog: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    var delegate: ConfirmDialogDelegate?
    
    static func loadView() -> ConfirmDialog {
        return self.loadView(fromNib: "ConfirmDialog") ?? ConfirmDialog()
    }
    
    func loadContent(type: ConfirmDialogType) {
        switch type {
        case .quitLearn:
            self.titleLabel.text = LocalizationText.dontQuit
            self.descriptionLabel.text = LocalizationText.almostDone
            self.acceptLabel.text = LocalizationText.finish
            self.cancelLabel.text = LocalizationText.continueLearning
        }
        
        self.layoutIfNeeded()
    }
    
    // MARK: - Touches began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first?.view == self.backgroundView {
            self.dismiss()
        }
    }
    
    @IBAction func didTapAccept(_ sender: Any) {
        delegate?.confirmDialogDidTapAccept(self)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss()
    }
}
