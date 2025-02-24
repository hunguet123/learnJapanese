import UIKit

class TextSelectionView: UIView {
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    private let stackView = UIStackView()
    private var selectedOption: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // Configure stack view
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        // Add stack view to the main view
        addSubview(stackView)
        addSubview(questionLabel)
        
        // Set up stack view constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
//        questionLabel.text = "Đây là chữ gì"
//        // Add options to stack view
//        addOption(title: "犬（いぬ）")
//        addOption(title: "猫（ねこ）")
//        addOption(title: "熊（くま）")
//        addOption(title: "鳥（とり）")
    }
    
    func addQuestionText(text: String) {
        self.questionLabel.text = text
    }
    
    func addOption(title: String, isSelected: Bool = false) {
        let optionView = UIView()
        optionView.backgroundColor = isSelected ? .white : UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        optionView.layer.cornerRadius = 8
        optionView.layer.borderWidth = isSelected ? 2 : 0
        optionView.layer.borderColor = isSelected ? UIColor.systemPink.cgColor : UIColor.clear.cgColor
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 20)
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .systemOrange
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let optionStack = UIStackView(arrangedSubviews: [label, button])
        optionStack.axis = .horizontal
        optionStack.alignment = .center
        optionStack.spacing = 10
        optionStack.distribution = .fill
        
        optionView.addSubview(optionStack)
        
        // Set up option stack view constraints
        optionStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            optionStack.topAnchor.constraint(equalTo: optionView.topAnchor, constant: 10),
            optionStack.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: 10),
            optionStack.trailingAnchor.constraint(equalTo: optionView.trailingAnchor, constant: -10),
            optionStack.bottomAnchor.constraint(equalTo: optionView.bottomAnchor, constant: -10)
        ])
        
        // Add tap gesture recognizer to the option view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(optionTapped(_:)))
        optionView.addGestureRecognizer(tapGesture)
        
        stackView.addArrangedSubview(optionView)
        
        if isSelected {
            selectedOption = optionView
        }
    }
    
    @objc private func optionTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        
        // Update previous selected option view
        if let previousSelectedOption = selectedOption {
            previousSelectedOption.layer.borderWidth = 0
            previousSelectedOption.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        }
        
        // Update tapped option view
        tappedView.layer.borderWidth = 2
        tappedView.layer.borderColor = UIColor.systemPink.cgColor
        tappedView.backgroundColor = .white
        
        // Set the new selected option
        selectedOption = tappedView
    }
}
