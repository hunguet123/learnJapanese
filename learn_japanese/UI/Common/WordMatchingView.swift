import UIKit
import Foundation

struct WordPair: Codable, Equatable {
    let left: String
    let right: String
}

struct WordMatchingQuestion: Codable {
    let questionType: String
    let questionText: String
    let wordPairs: [WordPair]
    
    // Hàm fromJson
    static func fromJson(_ jsonString: String) -> WordMatchingQuestion? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(WordMatchingQuestion.self, from: jsonData)
    }
    
    // Hàm toJson
    func toJson() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
}

class WordMatchingView: UIView {
    var wordPairs: [WordPair] = [] {
        didSet {
            updateUI()
        }
    }
    
    var textQuestion: String = "" {
        didSet {
            textQuestionLabel.text = textQuestion
        }
    }
    
    private let textQuestionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = AppColors.titleText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Mảng lưu trữ các từ đã được chọn
    var selectedWords: [String] = []
    
    // Mảng lưu trữ các button
    var wordButtons: [UIButton] = []
    
    // Số cặp từ đã ghép đúng
    private var correctPairs = 0
    
    var onDidTapContinueButton: (() -> Void)?
    
    // Button tiếp tục
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationText.continueMessage, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = AppColors.continueButtonDisabled
        button.setTitleColor(.gray, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Thêm shadow effect
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var leftColumnButtons: Set<UIButton> = []
    private var rightColumnButtons: Set<UIButton> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = AppColors.viewBackground
        
        // Container View để tạo margin
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        // Tiêu đề
        let titleLabel = textQuestionLabel
        containerView.addSubview(titleLabel)
        
        // Stack view chính
        let mainStackView = createMainStackView()
        containerView.addSubview(mainStackView)
        
        // Thêm button tiếp tục
        addSubview(continueButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            continueButton.topAnchor.constraint(greaterThanOrEqualTo: mainStackView.bottomAnchor, constant: 30),
            continueButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            continueButton.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            continueButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createMainStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Tạo và lưu trữ các button theo cột
        let leftColumn = createColumn(words: wordPairs.map { $0.left }, isLeftColumn: true)
        let rightColumn = createColumn(words: wordPairs.map { $0.right }, isLeftColumn: false)
        
        stackView.addArrangedSubview(leftColumn)
        stackView.addArrangedSubview(rightColumn)
        
        return stackView
    }
    
    private func createColumn(words: [String], isLeftColumn: Bool) -> UIStackView {
        let column = UIStackView()
        column.axis = .vertical
        column.spacing = 12
        column.distribution = .fillEqually
        
        let shuffledWords = words.shuffled()
        
        for word in shuffledWords {
            let button = createWordButton(with: word)
            column.addArrangedSubview(button)
            wordButtons.append(button)
            
            // Lưu button vào set tương ứng
            if isLeftColumn {
                leftColumnButtons.insert(button)
            } else {
                rightColumnButtons.insert(button)
            }
        }
        
        return column
    }
    
    private func createWordButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.backgroundColor = AppColors.buttonBackground
        button.setTitleColor(AppColors.titleText, for: .normal)
        button.layer.cornerRadius = 12
        
        // Shadow effect
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(wordButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc private func wordButtonTapped(_ sender: UIButton) {
        guard let word = sender.titleLabel?.text else { return }
        
        // Kiểm tra xem button đã được chọn trước đó chưa
        if selectedWords.contains(word) {
            // Bỏ chọn từ
            selectedWords.removeAll { $0 == word }
            animateButtonDeselection(sender)
            return
        }
        
        // Kiểm tra nếu đã có một từ được chọn
        if selectedWords.count == 1 {
            let firstSelectedButton = wordButtons.first { button in
                button.titleLabel?.text == selectedWords[0]
            }
            
            // Kiểm tra xem hai button có cùng cột không
            if let firstButton = firstSelectedButton {
                let bothInLeftColumn = leftColumnButtons.contains(firstButton) && leftColumnButtons.contains(sender)
                let bothInRightColumn = rightColumnButtons.contains(firstButton) && rightColumnButtons.contains(sender)
                
                if bothInLeftColumn || bothInRightColumn {
                    return
                }
            }
        }
        
        // Tiếp tục xử lý chọn từ bình thường
        selectedWords.append(word)
        animateButtonSelection(sender)
        
        if selectedWords.count == 2 {
            checkForMatch()
        }
    }
    
    private func checkForMatch() {
        let firstWord = selectedWords[0]
        let secondWord = selectedWords[1]
        
        let selectedButtons = wordButtons.filter { button in
            selectedWords.contains(button.titleLabel?.text ?? "")
        }
        
        if wordPairs.contains(where: { $0 == WordPair(left: firstWord, right: secondWord) || $0 == WordPair(left: secondWord, right: firstWord) }) {
            // Ghép đúng
            correctPairs += 1
            animateCorrectMatch(buttons: selectedButtons)
            checkGameCompletion()
        } else {
            // Ghép sai
            animateWrongMatch(buttons: selectedButtons)
        }
    }
    
    private func animateButtonSelection(_ button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            button.backgroundColor = AppColors.selectedButtonBackground
            button.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            button.setTitleColor(.white, for: .normal)
        }
    }
    
    private func animateButtonDeselection(_ button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            button.backgroundColor = AppColors.buttonBackground
            button.transform = .identity
            button.setTitleColor(AppColors.titleText, for: .normal)
        }
    }
    
    private func animateCorrectMatch(buttons: [UIButton]) {
        UIView.animate(withDuration: 0.5) {
            buttons.forEach { button in
                button.backgroundColor = AppColors.correctMatchBackground
                button.isEnabled = false
                button.transform = .identity
            }
        }
        selectedWords.removeAll()
    }
    
    private func animateWrongMatch(buttons: [UIButton]) {
        // Hiệu ứng rung và viền đỏ
        buttons.forEach { button in
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.red.cgColor
            
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            animation.duration = 0.6
            animation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
            button.layer.add(animation, forKey: "shake")
        }
        
        // Reset sau 1 giây
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            buttons.forEach { button in
                UIView.animate(withDuration: 0.3) {
                    button.layer.borderWidth = 0
                    button.backgroundColor = AppColors.buttonBackground
                    button.transform = .identity
                    button.setTitleColor(AppColors.titleText, for: .normal)
                }
            }
            self.selectedWords.removeAll()
        }
    }
    
    private func checkGameCompletion() {
        if correctPairs == wordPairs.count {
            UIView.animate(withDuration: 0.3) {
                self.continueButton.isEnabled = true
                self.continueButton.backgroundColor = AppColors.continueButtonEnabled
            }
        }
    }
    
    private func updateUI() {
        // Xóa các button cũ
        wordButtons.forEach { $0.removeFromSuperview() }
        wordButtons.removeAll()
        leftColumnButtons.removeAll()
        rightColumnButtons.removeAll()
        
        // Tạo lại các button và cột
        let mainStackView = createMainStackView()
        if let containerView = subviews.first {
            containerView.addSubview(mainStackView)
            
            // Constraints
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: containerView.subviews.first { $0 is UILabel }!.bottomAnchor, constant: 30),
                mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ])
        }
    }
    
    @objc private func continueButtonTapped() {
        onDidTapContinueButton?()
    }
}
