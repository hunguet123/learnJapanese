import UIKit
import AVFoundation

class ImageSelectionView: UIView {
    // MARK: - Callbacks
    var onTapContinueButton: ((Int?) -> Void)?
    
    // MARK: - Properties
    private var options: [(image: UIImage?, isSelected: Bool)] = []
    private var selectedIndex: Int?
    private var audioName: String = ""
    
    var textQuestion: String? {
        didSet {
            questionLabel.text = textQuestion
        }
    }
    
    // MARK: - UI Components
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var translationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = AppColors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var optionsGridView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var topRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var bottomRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
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
    
    private lazy var audioButton: UIButton = {
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
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = AppColors.backgroundColor
        
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(questionLabel)
        containerStackView.addArrangedSubview(noteLabel)
        containerStackView.addArrangedSubview(translationLabel)
        containerStackView.addArrangedSubview(optionsGridView)
        
        optionsGridView.addArrangedSubview(topRowStack)
        optionsGridView.addArrangedSubview(bottomRowStack)
        
        addSubview(continueButton)
        addSubview(audioButton)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: audioButton.bottomAnchor, constant: 0),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            optionsGridView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            optionsGridView.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.7),
            
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            continueButton.topAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: 20),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            audioButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            audioButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            audioButton.widthAnchor.constraint(equalToConstant: 50),
            audioButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Public Methods
    func addOption(imageName: String, isSelected: Bool = false) {
        let containerView = createOptionView(imageName: imageName)
        
        // Determine which row to add the option
        let currentIndex = options.count
        if currentIndex < 2 {
            topRowStack.addArrangedSubview(containerView)
        } else if currentIndex < 4 {
            bottomRowStack.addArrangedSubview(containerView)
        } else {
            print("Warning: Maximum 4 options allowed")
            return
        }
        
        options.append(((containerView.subviews.first as? UIImageView)?.image, isSelected))
    }
    
    func addNote(text: String) {
        noteLabel.text = text
    }
    
    func addTranslation(text: String) {
        translationLabel.text = text
    }
    
    func addAudio(audioName: String) {
        self.audioName = audioName
        audioButton.isHidden = false
    }
    
    private func createOptionView(imageName: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.2
        containerView.clipsToBounds = true
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: imageName)
        
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOptionTap(_:)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
        
        return containerView
    }
    
    // MARK: - Private Methods
    @objc private func handleOptionTap(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view else { return }
        
        var index: Int?
        if let topIndex = topRowStack.arrangedSubviews.firstIndex(of: tappedView) {
            index = topIndex
        } else if let bottomIndex = bottomRowStack.arrangedSubviews.firstIndex(of: tappedView) {
            index = bottomIndex + 2
        }
        
        guard let selectedIndex = index else { return }
        self.selectedIndex = selectedIndex
        updateSelection()
        updateContinueButtonState(enabled: true)
    }
    
    @objc private func audioButtonTapped() {
        AudioUtils.shared.playSound(filename: audioName)
    }
    
    private func updateSelection() {
        let allViews = topRowStack.arrangedSubviews + bottomRowStack.arrangedSubviews
        for (index, view) in allViews.enumerated() {
            UIView.animate(withDuration: 0.2) {
                view.layer.borderWidth = index == self.selectedIndex ? 4 : 0
                view.layer.borderColor = UIColor.systemBlue.cgColor
                view.transform = index == self.selectedIndex ?
                    CGAffineTransform(scaleX: 1.05, y: 1.05) :
                    .identity
            }
        }
    }
    
    private func updateContinueButtonState(enabled: Bool) {
        continueButton.isEnabled = enabled
        continueButton.backgroundColor = enabled ? AppColors.continueButtonEnabled : AppColors.continueButtonDisabled
    }
    
    @objc private func continueButtonTapped() {
        onTapContinueButton?(selectedIndex)
    }
}
