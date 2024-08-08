//
//  LearnSectionViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 8/8/24.
//

import UIKit

class LearnSectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapCloseLearnSection(_ sender: Any) {
        let confirmDialog = ConfirmDialog.loadView()
        confirmDialog.loadContent(type: .quitLearn)
        confirmDialog.delegate = self
        confirmDialog.show(in: self.view)
    }
}
