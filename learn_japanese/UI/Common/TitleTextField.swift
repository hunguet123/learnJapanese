//
//  TitleTextField.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 21/7/24.
//

import UIKit

protocol TitleTextFieldDelegate {
    func titleTextField(_ textField: UITextField, onChanged newText: String)
}

class TitleTextField: UIView {
    var delegate: TitleTextFieldDelegate?
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = AppColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightViewMode = .always
        textField.backgroundColor = AppColor.white
        textField.layer.borderColor = AppColor.goldenPoppy?.cgColor
        textField.layer.borderWidth = 1.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        setupUI()
        setTitle(title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(textField)
        backgroundColor = AppColor.backgroundColor
        textField.delegate = self
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            textField.heightAnchor.constraint(equalToConstant: 39),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setText(_ text: String) {
        textField.text = text
    }
    
    func setHintText(_ text: String) {
        textField.placeholder = text
    }
    
    func getText() -> String? {
        return textField.text
    }
    
    func setPlaceholder(_ placeholder: String) {
        textField.placeholder = placeholder
    }
    
    func setTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
}

extension TitleTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        self.delegate?.titleTextField(textField, onChanged: newText)
        return true;
    }
}
