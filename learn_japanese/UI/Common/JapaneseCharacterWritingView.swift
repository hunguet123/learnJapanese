import UIKit
import AVFoundation
import Lottie
import MLKitDigitalInkRecognition


struct WritingQuestionModel: Codable {
    let questionType: String
    let audio: String
    let animation: String
    let questionText: String
    let correctAnswer: String
    
    // Hàm parse từ JSON string
    static func fromJson(_ jsonString: String) -> WritingQuestionModel? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let model = try JSONDecoder().decode(WritingQuestionModel.self, from: data)
            return model
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    // Hàm chuyển model sang JSON string
    func toJson() -> String? {
        do {
            let data = try JSONEncoder().encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Error encoding to JSON: \(error)")
            return nil
        }
    }
}

class JapaneseCharacterWritingView: UIView, DrawableViewDelegate {
    // MARK: - Properties
    
    // Closure callback cho kết quả kiểm tra
    var onCheckResult: ((Bool, [DigitalInkRecognitionCandidate], String) -> Void)?
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let videoPlayerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer()
        layer.videoGravity = .resizeAspect
        return layer
    }()
    
    private let videoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let audioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let replayVideoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var writingArea: DrawingView = {
        let view = DrawingView()
        view.delegate = self
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
    
    private let undoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.uturn.backward"), for: .normal)
        button.tintColor = .systemOrange
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var recognizer: DigitalInkRecognizer?
    private var currentCharacter: String = ""
    private var audioUrl: String = ""
    private var player: AVPlayer?
    
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
    
    func didDraw(stroke: [NSValue]) {
        
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white
        
        // Thêm videoContainerView vào view chính
        addSubview(videoContainerView)
        
        // Thêm videoPlayerLayer vào videoContainerView
        videoContainerView.layer.addSublayer(videoPlayerLayer)
        
        // Thêm các view con khác
        addSubview(questionLabel)
        addSubview(audioButton)
        addSubview(replayVideoButton)
        addSubview(writingArea)
        addSubview(checkButton)
        addSubview(clearButton)
        addSubview(undoButton)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            // Video Container View - Đặt ở vị trí trên cùng
            videoContainerView.topAnchor.constraint(equalTo: questionLabel.topAnchor, constant: 20),
            videoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            videoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            videoContainerView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            audioButton.topAnchor.constraint(equalTo: replayVideoButton.bottomAnchor, constant: 5.0),
            audioButton.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor),
            audioButton.widthAnchor.constraint(equalToConstant: 50),
            audioButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Replay Button
            replayVideoButton.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
            replayVideoButton.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor),
            replayVideoButton.widthAnchor.constraint(equalToConstant: 44),
            replayVideoButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Writing Area - Đặt bên dưới videoContainerView
            writingArea.topAnchor.constraint(equalTo: videoContainerView.bottomAnchor, constant: 20),
            writingArea.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            writingArea.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            writingArea.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            
            // Undo Button
            undoButton.topAnchor.constraint(equalTo: writingArea.bottomAnchor, constant: 20),
            undoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            undoButton.widthAnchor.constraint(equalToConstant: 44),
            undoButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Check Button
            checkButton.topAnchor.constraint(equalTo: writingArea.bottomAnchor, constant: 20),
            checkButton.leadingAnchor.constraint(equalTo: undoButton.trailingAnchor, constant: 12),
            checkButton.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -12),
            checkButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Clear Button
            clearButton.topAnchor.constraint(equalTo: writingArea.bottomAnchor, constant: 20),
            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            clearButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        // Thêm action cho các button
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        replayVideoButton.addTarget(self, action: #selector(replayVideoTapped), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPlayerLayer.frame = videoContainerView.bounds
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
    func setData(writingQuestion: WritingQuestionModel) {
        questionLabel.text = writingQuestion.questionText
        currentCharacter = writingQuestion.correctAnswer
        self.audioUrl = writingQuestion.audio
        // Load animation
        if let videoURL = Bundle.main.url(forResource: writingQuestion.animation, withExtension: "mp4") {
            player = AVPlayer(url: videoURL)
            videoPlayerLayer.player = player
            player?.play()
        }
        
        // Xóa vùng vẽ
        writingArea.clear()
    }
    
    // MARK: - Actions
    @objc private func checkButtonTapped() {
        guard let recognizer = recognizer else { return }
        
        let ink = Ink(strokes: writingArea.getStrokes())
    
        recognizer.recognize(ink: ink) { [weak self] result, error in
            guard let self = self, let result = result, error == nil else { return }
            
            // Lấy các kết quả nhận dạng hàng đầu
            let candidates = result.candidates.prefix(3)
            
            // Kiểm tra xem kết quả có chứa ký tự hiện tại không
            let isCorrect = candidates.first?.text == self.currentCharacter
            
            DispatchQueue.main.async {
                // Gọi callback thay vì hiển thị kết quả trực tiếp
                self.onCheckResult?(isCorrect, Array(candidates), self.currentCharacter)
            }
        }
    }
    
    @objc private func audioButtonTapped() {
        AudioUtils.shared.playSound(filename: audioUrl)
    }
    
    @objc private func clearButtonTapped() {
        writingArea.clear()
    }
    
    @objc private func undoButtonTapped() {
        writingArea.undo()
    }
    
    @objc private func replayVideoTapped() {
        player?.seek(to: .zero)
        player?.play()
    }
}

// MARK: - Helper Extension (giữ nguyên)
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
