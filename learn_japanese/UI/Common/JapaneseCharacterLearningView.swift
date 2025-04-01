import UIKit
import Lottie
import MLKitDigitalInkRecognition

class JapaneseCharacterWritingView: UIView {
    
    // MARK: - Properties
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let writingArea: DrawingView = {
        let view = DrawingView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kiểm tra", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Xóa", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var recognizer: DigitalInkRecognizer?
    private var currentCharacter: String = ""
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupRecognizer()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(animationView)
        addSubview(writingArea)
        addSubview(checkButton)
        addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            animationView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            
            writingArea.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 20),
            writingArea.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            writingArea.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            writingArea.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            
            checkButton.topAnchor.constraint(equalTo: writingArea.bottomAnchor, constant: 20),
            checkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            checkButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            checkButton.heightAnchor.constraint(equalToConstant: 44),
            
            clearButton.topAnchor.constraint(equalTo: writingArea.bottomAnchor, constant: 20),
            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            clearButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            clearButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    
    private func setupRecognizer() {
        let identifier = DigitalInkRecognitionModelIdentifier(forLanguageTag: "ja")!
        let model = DigitalInkRecognitionModel(modelIdentifier: identifier)
        let conditions = ModelDownloadConditions(allowsCellularAccess: true,
                                               allowsBackgroundDownloading: true)
        
        ModelManager.modelManager().download(model, conditions: conditions)
        
        // Tạo recognizer thông qua factory method
        let options = DigitalInkRecognizerOptions(model: model)
        self.recognizer = DigitalInkRecognizer.digitalInkRecognizer(options: options)
    }
    
    // MARK: - Public Methods
    func setCharacter(_ character: String, animationName: String) {
        currentCharacter = character
        
        // Load animation
        if let animation = LottieAnimation.named(animationName) {
            animationView.animation = animation
            animationView.play()
        }
    }
    
    // MARK: - Actions
    @objc private func checkButtonTapped() {
        guard let recognizer = recognizer else { return }
        
        let ink = Ink(strokes: writingArea.getStrokes())
        
        recognizer.recognize(ink: ink) { [weak self] result, error in
            guard let result = result, error == nil else { return }
            
            if let topCandidate = result.candidates.first {
                let isCorrect = topCandidate.text == self?.currentCharacter
                self?.showResult(isCorrect: isCorrect)
            }
        }
    }
    
    @objc private func clearButtonTapped() {
        writingArea.clear()
    }
    
    private func showResult(isCorrect: Bool) {
        let alert = UIAlertController(
            title: isCorrect ? "Chính xác!" : "Chưa chính xác",
            message: isCorrect ? "Bạn đã viết đúng!" : "Hãy thử lại nhé",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let viewController = self.findViewController() {
            viewController.present(alert, animated: true)
        }
    }
}

// MARK: - DrawingView
class DrawingView: UIView {
    private var currentPath: UIBezierPath?
    private var currentStroke: [StrokePoint] = []
    private var strokes: [[StrokePoint]] = []
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.addSublayer(shapeLayer)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 3
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        currentPath = UIBezierPath()
        currentPath?.move(to: touch.location(in: self))
        currentStroke = [StrokePoint(x: Float(touch.location(in: self).x),
                                   y: Float(touch.location(in: self).y),
                                     t: Int(Int64(touch.timestamp * 1000)))]
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let path = currentPath else { return }
        let point = touch.location(in: self)
        path.addLine(to: point)
        currentStroke.append(StrokePoint(x: Float(point.x),
                                       y: Float(point.y),
                                         t: Int(Int64(touch.timestamp * 1000))))
        shapeLayer.path = path.cgPath
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !currentStroke.isEmpty {
            strokes.append(currentStroke)
            currentStroke = []
        }
    }
    
    func clear() {
        currentPath = nil
        strokes = []
        shapeLayer.path = nil
    }
    
    func getStrokes() -> [Stroke] {
        return strokes.map { points in
            Stroke(points: points)
        }
    }
}

// MARK: - Helper Extension
extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

