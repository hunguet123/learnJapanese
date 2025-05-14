//
//  TitleTextField.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 21/7/24.
//

import UIKit

protocol TitleTextFieldDelegate {
    func titleTextField(_ textField: UITextField, onChanged newText: String)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
}

class TitleTextField: UIView {
    var delegate: TitleTextFieldDelegate?
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = AppColors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.backgroundColor = AppColors.white
        textField.textColor = AppColors.black
        textField.layer.borderColor = AppColors.goldenPoppy?.cgColor
        textField.layer.borderWidth = 1.0
        textField.returnKeyType = .continue
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Container view cho nút toggle
    private let rightViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var togglePasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = AppColors.darkLiver
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private var isPasswordField: Bool = false
    
    init(title: String) {
        super.init(frame: .zero)
        setupUI()
        setTitle(title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setText(_ text: String) {
        textField.text = text
    }
    
    func setHintText(_ text: String) {
        textField.attributedPlaceholder = NSAttributedString(string: text, attributes: [
            .foregroundColor: AppColors.darkLiver ?? .black])
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
    
    func setKeyboardType(_ keyboardType: UIKeyboardType) {
        textField.keyboardType = keyboardType
    }
    
    func setReturnKeyType(_ returnKeyType: UIReturnKeyType) {
        textField.returnKeyType = returnKeyType
    }
    
    func setContentType(_ textContentType: UITextContentType) {
        textField.textContentType = textContentType
    }
    
    func setSecureText(_ isSecureTextEntry: Bool) {
        isPasswordField = isSecureTextEntry
        textField.isSecureTextEntry = isSecureTextEntry
        togglePasswordButton.isHidden = !isSecureTextEntry
        
        if isSecureTextEntry {
            // Mặc định hiển thị biểu tượng eye.slash khi mật khẩu bị ẩn
            togglePasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    func setTag(_ tagTextField: Int) {
        textField.tag = tagTextField
    }
    
    func textFieldBecomFirstResponder() {
        textField.becomeFirstResponder()
    }
    
    func textFieldResignFirstResponder() {
        textField.resignFirstResponder()
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(rightViewContainer)
        rightViewContainer.addSubview(togglePasswordButton)
        
        backgroundColor = AppColors.backgroundColor
        textField.delegate = self
        
        // Thêm action cho nút toggle
        togglePasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            textField.heightAnchor.constraint(equalToConstant: 39),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Container cho nút toggle
            rightViewContainer.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            rightViewContainer.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            rightViewContainer.widthAnchor.constraint(equalToConstant: 40),
            rightViewContainer.heightAnchor.constraint(equalTo: textField.heightAnchor),
            
            // Nút toggle trong container
            togglePasswordButton.centerXAnchor.constraint(equalTo: rightViewContainer.centerXAnchor),
            togglePasswordButton.centerYAnchor.constraint(equalTo: rightViewContainer.centerYAnchor),
            togglePasswordButton.widthAnchor.constraint(equalToConstant: 30),
            togglePasswordButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Thiết lập padding bên phải cho textField
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: textField.frame.height))
        textField.rightViewMode = .always
    }
    
    @objc private func togglePasswordVisibility() {
        // Đảo ngược trạng thái hiện tại của isSecureTextEntry
        textField.isSecureTextEntry.toggle()
        
        // Cập nhật icon dựa trên trạng thái hiện tại
        if textField.isSecureTextEntry {
            // Nếu mật khẩu đang bị ẩn (isSecureTextEntry = true), hiển thị biểu tượng "eye.slash"
            togglePasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            // Nếu mật khẩu đang hiển thị (isSecureTextEntry = false), hiển thị biểu tượng "eye"
            togglePasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        
        // Giữ vị trí con trỏ sau khi chuyển đổi
        if let existingText = textField.text, !existingText.isEmpty {
            let currentText = textField.text
            textField.text = nil
            textField.text = currentText
        }
    }
}

extension TitleTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        self.delegate?.titleTextField(textField, onChanged: newText)
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.delegate?.textFieldShouldReturn(textField) ?? true
    }
}
