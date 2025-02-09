import UIKit

class SwipeView: UIView {
    // MARK: - Properties
    var currentCharacter: String = "" {
        didSet {
            loadCharacter()
        }
    }
    
    var onSwipeLeft: ((String) -> Void)? // Callback khi vuốt trái
    var onSwipeRight: ((String) -> Void)? // Callback khi vuốt phải
    
    private var originalCenter: CGPoint = .zero
    
    // UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.text = "Chưa thuộc"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .red
        label.alpha = 0 // Ban đầu ẩn
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.text = "Đã thuộc"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .red
        label.alpha = 0 // Ban đầu ẩn
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestures()
        loadCharacter()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupGestures()
        loadCharacter()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(imageView)
        
        // Layout labels
        NSLayoutConstraint.activate([
            leftLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -100),
            
            rightLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 100),
            
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)
        ])
    }
    
    // MARK: - Setup Gestures
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Load Character
    private func loadCharacter() {
        imageView.image = UIImage(named: currentCharacter)
    }
    
    // MARK: - Handle Pan Gesture
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            originalCenter = imageView.center
        case .changed:
            // Di chuyển hình ảnh cùng cử chỉ
            imageView.center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            
            // Hiệu ứng nghiêng nhẹ
            let rotationAngle = translation.x / (bounds.width / 4)
            imageView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            // Điều chỉnh độ mờ của label dựa trên khoảng cách kéo
            let alpha = abs(translation.x) / (bounds.width / 2)
            if translation.x > 0 { // Vuốt phải
                rightLabel.alpha = min(alpha, 1.0)
                leftLabel.alpha = 0
            } else { // Vuốt trái
                leftLabel.alpha = min(alpha, 1.0)
                rightLabel.alpha = 0
            }
        case .ended:
            // Kiểm tra hướng vuốt
            if translation.x > 100 {
                onSwipeRight?(currentCharacter) // Gọi callback vuốt phải
            } else if translation.x < -100 {
                onSwipeLeft?(currentCharacter) // Gọi callback vuốt trái
            }
            resetImagePosition()
        default:
            break
        }
    }
    
    // MARK: - Reset Image Position
    private func resetImagePosition() {
        UIView.animate(withDuration: 0.3) {
            self.imageView.center = self.originalCenter
            self.imageView.transform = .identity
            self.leftLabel.alpha = 0
            self.rightLabel.alpha = 0
        }
    }
}
