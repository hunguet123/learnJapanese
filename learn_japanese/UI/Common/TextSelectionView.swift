import UIKit

class TextSelectionView: UIView {
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let audioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.isHidden = true
        button.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var questionImageHeightConstraint: NSLayoutConstraint?
    private var noteLabelHeightConstraint: NSLayoutConstraint?
    
    private let stackView = UIStackView()
    private var selectedIndex = 0
    private var selectedOption: UIView? {
        didSet {
            nextButton.isEnabled = true
            nextButton.backgroundColor = AppColors.buttonEnable
            nextButton.layer.borderColor = AppColors.buttonEnable.cgColor
            if let selectedOption = selectedOption {
                selectedIndex = stackView.arrangedSubviews.firstIndex(of: selectedOption) ?? 0
            }
        }
    }
    private let nextButton: UIButton = {
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
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    private var audioItems: [String] = []
    private var questionAudio: String = ""
    
    var didTapNextQuestion: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        
        // Configure stack view
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        // Add subviews
        addSubview(questionLabel)
        addSubview(questionImageView)
        addSubview(noteLabel)
        addSubview(stackView)
        addSubview(nextButton)
        addSubview(audioButton)
        
        // Disable translatesAutoresizingMaskIntoConstraints
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionImageView.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            // Question Label
            questionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Question Image View
            questionImageView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10),
            questionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            questionImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
        
        // Tạo constraint chiều cao và lưu trữ nó
        questionImageHeightConstraint = questionImageView.heightAnchor.constraint(equalToConstant: 0)
        questionImageHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            // Note Label
            noteLabel.topAnchor.constraint(equalTo: questionImageView.bottomAnchor, constant: 10),
            noteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            noteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
        
        // Tạo constraint chiều cao cho Note Label và lưu trữ nó
        noteLabelHeightConstraint = noteLabel.heightAnchor.constraint(equalToConstant: 0)
        noteLabelHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            // Stack View
            stackView.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Next Button
            nextButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            audioButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            audioButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            audioButton.heightAnchor.constraint(equalToConstant: 50),
            audioButton.widthAnchor.constraint(equalTo: audioButton.heightAnchor),
        ])
    }

    
    func addNote(note: String?) {
        self.noteLabel.text = note
        self.noteLabelHeightConstraint?.constant = note == nil ? 0 : 30
    }
    
    func addQuestionText(text: String) {
        self.questionLabel.text = text
    }
    
    func addQuestionImage(image: UIImage?) {
        self.questionImageView.image = image
        
        // Cập nhật chiều cao của questionImageView dựa trên ảnh
        if image == nil {
            questionImageHeightConstraint?.constant = 0
            audioButton.isHidden = true
        } else {
            questionImageHeightConstraint?.constant = 200
            audioButton.isHidden = false
        }
        
        // Cập nhật giao diện
        self.layoutIfNeeded()
    }
    
    func addQuestionAudio(questionAudio: String) {
        self.questionAudio = questionAudio
    }
    
    func addOption(title: String,
                   isSelected: Bool = false,
                   audioName: String
    ) {
        audioItems.append(audioName)
        let optionView = UIView()
        optionView.backgroundColor = isSelected ? .white : UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        optionView.layer.cornerRadius = 12
        optionView.layer.borderWidth = isSelected ? 2 : 0
        optionView.layer.borderColor = isSelected ? UIColor.systemPink.cgColor : UIColor.clear.cgColor
        
        let label = UILabel()
        label.textColor = .black
        label.text = title
        label.font = UIFont.systemFont(ofSize: 22)
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .systemOrange
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.isHidden = self.questionImageView.image != nil || audioName.isEmpty
        
        let optionStack = UIStackView(arrangedSubviews: [label, button])
        optionStack.axis = .horizontal
        optionStack.alignment = .center
        optionStack.spacing = 10
        optionStack.distribution = .fill
        
        optionView.addSubview(optionStack)
        
        // Set up option stack view constraints
        optionStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            optionStack.topAnchor.constraint(equalTo: optionView.topAnchor, constant: 12),
            optionStack.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: 12),
            optionStack.trailingAnchor.constraint(equalTo: optionView.trailingAnchor, constant: -12),
            optionStack.bottomAnchor.constraint(equalTo: optionView.bottomAnchor, constant: -12)
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
    
    @objc private func didTapButton(_ sender: UIButton) {
        if let superview = sender.superview?.superview, let index = stackView.arrangedSubviews.firstIndex(of: superview) {
            playAudio(audioName: self.audioItems[index])
        }
    }
    
    @objc private func nextButtonTapped() {
        didTapNextQuestion?(selectedIndex)
    }
    
    @objc private func audioButtonTapped() {
        playAudio(audioName: self.questionAudio)
    }
    
    private func playAudio(audioName: String) {
        if AudioUtils.shared.isPlaying() {
            AudioUtils.shared.stopSound()
        } else {
            AudioUtils.shared.playSound(filename: audioName)
        }
    }
}
