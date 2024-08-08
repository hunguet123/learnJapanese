//
//  LearnSectionViewControllerExtension.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 8/8/24.
//

import Foundation

extension LearnSectionViewController: ConfirmDialogDelegate {
    func confirmDialogDidTapAccept(_ confirmDialog: ConfirmDialog) {
        self.navigationController?.popViewController(animated: true)
    }
}
