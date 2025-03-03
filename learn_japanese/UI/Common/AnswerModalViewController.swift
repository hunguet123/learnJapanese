//
//  AnswerModalViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 3/3/25.
//

import UIKit

class AnswerModalViewController: UIViewController {
     var completionHandler: (() -> Void)?
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 10
        return view
    }()
    
    private let resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationText.continueMessage, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.4, alpha: 1)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    var isCorrect: Bool = false
    var explanation: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureModal()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(containerView)
        
        containerView.addSubview(resultImageView)
        containerView.addSubview(resultLabel)
        containerView.addSubview(explanationLabel)
        containerView.addSubview(continueButton)
        
        continueButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 400),
            
            resultImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            resultImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            resultImageView.widthAnchor.constraint(equalToConstant: 100),
            resultImageView.heightAnchor.constraint(equalToConstant: 100),
            
            resultLabel.topAnchor.constraint(equalTo: resultImageView.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            explanationLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 10),
            explanationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            explanationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            continueButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            continueButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 200),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.completionHandler?()
    }
    
    private func configureModal() {
        if isCorrect {
            // Trạng thái ĐÚNG
            resultImageView.image = UIImage(systemName: "checkmark.circle.fill")
            resultImageView.tintColor = .systemGreen
            resultLabel.text = LocalizationText.correct
            resultLabel.textColor = .systemGreen
        } else {
            // Trạng thái SAI
            resultImageView.image = UIImage(systemName: "xmark.circle.fill")
            resultImageView.tintColor = .systemRed
            resultLabel.text = LocalizationText.incorrect
            resultLabel.textColor = .systemRed
        }
        
        explanationLabel.text = explanation
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Convenience Initializer
    convenience init(isCorrect: Bool, explanation: String, completionHandler: (() -> Void)? = nil) {
        self.init()
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
        self.isCorrect = isCorrect
        self.explanation = explanation
        self.completionHandler = completionHandler
    }
}
