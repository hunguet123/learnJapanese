import UIKit
import AVFoundation
import Speech
import Network

// MARK: - Models
public struct ReadingModel: Codable {
    var questionType: String
    var questionText: String
    var audio: String
    var image: String
    var correctAnswer: String
    var translation: String
    
    // Hàm khởi tạo từ JSON
    static func fromJson(_ jsonString: String) -> ReadingModel? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(ReadingModel.self, from: jsonData)
            return model
        } catch {
            print("Lỗi giải mã JSON: \(error)")
            return nil
        }
    }
    
    // Hàm chuyển đổi sang JSON
    func toJson() -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Lỗi mã hóa JSON: \(error)")
            return nil
        }
    }
    
    // Hàm khởi tạo mặc định
    init(
        questionType: String = "reading",
        questionText: String,
        audio: String,
        image: String,
        correctAnswer: String,
        translation: String
    ) {
        self.questionType = questionType
        self.questionText = questionText
        self.audio = audio
        self.image = image
        self.correctAnswer = correctAnswer
        self.translation = translation
    }
}

public class JapaneseReadingView: UIView {
    
    // MARK: - Callbacks
    public var onReadingResult: ((Bool) -> Void)?
    public var onError: ((Error) -> Void)?
    public var onPlaybackFinished: (() -> Void)?
    
    // MARK: - Public Properties
    public var content: ReadingModel? {
        didSet {
            loadContent()
        }
    }
    
    public var isRecording: Bool = false {
        didSet {
            microButton.isSelected = isRecording
            microButton.tintColor = isRecording ? .systemRed : .systemGreen
        }
    }
    
    // MARK: - UI Customization Properties
    public var textFont: UIFont {
        get { textLabel.font }
        set { textLabel.font = newValue }
    }
    
    public var translationFont: UIFont {
        get { translationLabel.font }
        set { translationLabel.font = newValue }
    }
    
    public var buttonTintColor: UIColor {
        get { speakerButton.tintColor }
        set {
            speakerButton.tintColor = newValue
            if !isRecording {
                microButton.tintColor = newValue
            }
        }
    }
    
    // MARK: - Private Properties
    private var speechRecognizer: SFSpeechRecognizer?
    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioPlayer: AVAudioPlayer?
    private var similarityThreshold: Double = 0.8
    private var networkMonitor = NWPathMonitor()
    private var offlineRecognitionActive = false
    private var lastRecognizedText: String = ""
    
    // MARK: - UI Elements
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
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
    
    private lazy var controlStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 40
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var speakerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(speakerTapped), for: .touchUpInside)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private lazy var microButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "mic.circle.fill"), for: .normal)
        button.setImage(UIImage(systemName: "stop.circle.fill"), for: .selected)
        button.tintColor = .systemGreen
        button.addTarget(self, action: #selector(microTapped), for: .touchUpInside)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
        
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupSpeechRecognition()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        setupSpeechRecognition()
    }
    
    deinit {
        stopRecording()
        audioPlayer?.stop()
        audioPlayer = nil
        networkMonitor.cancel()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(contentStack)
        contentStack.addArrangedSubview(imageView)
        contentStack.addArrangedSubview(textLabel)
        contentStack.addArrangedSubview(translationLabel)
        contentStack.addArrangedSubview(statusLabel)
        contentStack.addArrangedSubview(controlStack)
    
        controlStack.addArrangedSubview(speakerButton)
        controlStack.addArrangedSubview(microButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            imageView.widthAnchor.constraint(equalTo: contentStack.widthAnchor),
            
            controlStack.heightAnchor.constraint(equalToConstant: 60),
            speakerButton.heightAnchor.constraint(equalTo: controlStack.heightAnchor),
            speakerButton.widthAnchor.constraint(equalTo: speakerButton.heightAnchor),
//            controlStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
        ])
    }
    
    // MARK: - Speech Recognition Setup
    private func setupSpeechRecognition() {
        // Kiểm tra và yêu cầu quyền nhận dạng giọng nói
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self?.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))
                    // Kiểm tra xem nhận dạng giọng nói có khả dụng không
                    if let speechRecognizer = self?.speechRecognizer, !speechRecognizer.isAvailable {
                        self?.offlineRecognitionActive = true
                        self?.statusLabel.text = "Nhận dạng giọng nói không khả dụng - Sử dụng chế độ ngoại tuyến"
                        self?.statusLabel.textColor = .systemOrange
                        self?.statusLabel.isHidden = false
                    }
                case .denied, .restricted:
                    let error = NSError(domain: "SpeechRecognition",
                                        code: 403,
                                        userInfo: [NSLocalizedDescriptionKey: "Quyền nhận dạng giọng nói bị từ chối"])
                    self?.onError?(error)
                    self?.statusLabel.text = "Quyền nhận dạng giọng nói bị từ chối"
                    self?.statusLabel.textColor = .systemRed
                    self?.statusLabel.isHidden = false
                case .notDetermined:
                    let error = NSError(domain: "SpeechRecognition",
                                        code: 401,
                                        userInfo: [NSLocalizedDescriptionKey: "Quyền nhận dạng giọng nói chưa được xác định"])
                    self?.onError?(error)
                @unknown default:
                    break
                }
            }
        }
    }
    
    // MARK: - Content Management
    private func loadContent() {
        guard let content = content else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageView.image = UIImage(named: content.image)
            self.textLabel.text = content.questionText
            self.translationLabel.text = content.translation
        }
    }
    
    // MARK: - Button Actions
    @objc private func speakerTapped() {
        playAudio()
    }
    
    @objc private func microTapped() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    public func setSimilarityThreshold(_ threshold: Double) {
        similarityThreshold = max(0.0, min(1.0, threshold))
    }
    
    public func playCurrentAudio() {
        playAudio()
    }
    
    // MARK: - Audio Playback
    private func playAudio() {
        if let audioFileName = content?.audio {
            AudioUtils.shared.playSound(filename: audioFileName)
        }
    }
    
    // MARK: - Speech Recognition
    private func startRecording() {
        stopRecording()
        if AudioUtils.shared.isPlaying() {
            AudioUtils.shared.stopSound()
        }
        
        // Reset biến lưu kết quả tạm thời
        lastRecognizedText = ""
        
        // Khởi tạo lại audio engine
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine,
              let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable else {
            return
        }
        
        do {
            // Thiết lập audio session với cấu hình đầy đủ
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            // Chuẩn bị recognition request
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else {
                throw NSError(domain: "JapaneseReadingView",
                              code: 3,
                              userInfo: [NSLocalizedDescriptionKey: "Không thể tạo yêu cầu nhận dạng"])
            }
            
            // Thiết lập tùy chọn cho recognition request
            recognitionRequest.shouldReportPartialResults = true
            
            // Kiểm tra xem thiết bị có hỗ trợ nhận dạng ngoại tuyến không
            if #available(iOS 13, *) {
                recognitionRequest.requiresOnDeviceRecognition = true
            }
            
            // Lấy input node
            let inputNode = audioEngine.inputNode
            // Cài đặt tap trên input node với buffer size nhỏ hơn
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }
            
            // Bắt đầu audio engine
            audioEngine.prepare()
            try audioEngine.start()
            
            // Chuẩn bị recognition task
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                guard let self = self else { return }
                if let result = result {
                    let segments = result.bestTranscription.segments
                    let recognizedText = segments.map { $0.substring }.joined(separator: " ")
                    
                    // Cập nhật UI với kết quả tạm thời
                    if !recognizedText.isEmpty {
                        self.lastRecognizedText = recognizedText
                        DispatchQueue.main.async {
                            self.statusLabel.text = "Đang nghe: \(self.lastRecognizedText)"
                            self.statusLabel.textColor = .systemBlue
                            self.statusLabel.isHidden = false
                        }
                    }
                    
                    // Nếu là kết quả cuối cùng
                    if result.isFinal {
                        let finalText = self.lastRecognizedText
                        if !finalText.isEmpty {
                            self.compareResult(finalText)
                        }
                        self.stopRecording()
                    }
                }
                
                // Xử lý lỗi
                if let error = error {
                    self.handleRecognitionError(error)
                }
            }
            
            // Cập nhật trạng thái
            isRecording = true
            microButton.isSelected = true
            statusLabel.text = "Đang nghe..."
            statusLabel.textColor = .systemBlue
            statusLabel.isHidden = false
            
            // Thêm timeout tự động
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                guard let self = self else { return }
                if self.isRecording {
                    self.stopRecording()
                    if !self.lastRecognizedText.isEmpty {
                        self.compareResult(self.lastRecognizedText)
                    }
                }
            }
            
        } catch {
            onError?(error)
        }
    }
    
    private func handleRecognitionError(_ error: Error) {
        if !self.lastRecognizedText.isEmpty {
            self.compareResult(self.lastRecognizedText)
        }
        
        if let error = error as NSError?, error.domain == "kAFAssistantErrorDomain" {
            if error.code == 203 {
                DispatchQueue.main.async {
                    self.statusLabel.text = "Không phát hiện giọng nói. Vui lòng nói to hơn."
                    self.statusLabel.textColor = .systemOrange
                    self.statusLabel.isHidden = false
                }
            }
        } else {
            self.onError?(error)
        }
    }
    
    private func stopRecording() {
        // Kiểm tra nếu audioEngine đang chạy
        if let audioEngine = audioEngine, audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        // Đảm bảo kết thúc request và task
        self.recognitionRequest?.endAudio()
        self.recognitionTask?.cancel()
        self.recognitionTask?.finish()
        
        // Reset các biến một cách rõ ràng
        self.audioEngine = nil
        self.recognitionRequest = nil
        self.recognitionTask = nil
        
        // Cập nhật trạng thái
        self.isRecording = false
        self.microButton.isSelected = false
        
        deactiveAudioSession()
    }
    
    private func deactiveAudioSession() {
        if AudioUtils.shared.isPlaying() {
            return
        }
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("❌ Lỗi khi reset audio session: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Result Handling
    private func compareResult(_ recognizedText: String) {
        guard let content = content else { return }
        
        let similarity = calculateSimilarity(between: recognizedText, and: content.correctAnswer)
        onReadingResult?(similarity >= similarityThreshold)
    }
    
    private func calculateSimilarity(between str1: String, and str2: String) -> Double {
        // Implement text similarity algorithm - Levenshtein distance
        let distance = levenshteinDistance(str1.lowercased(), str2.lowercased())
        let maxLength = max(str1.count, str2.count)
        
        // Normalize to get similarity (0 to 1)
        return 1.0 - Double(distance) / Double(maxLength)
    }
    
    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        // Xử lý các trường hợp đặc biệt
        if s1.isEmpty { return s2.count }
        if s2.isEmpty { return s1.count }
        if s1 == s2 { return 0 }
        
        // Sử dụng chuỗi ngắn hơn làm cột để giảm không gian bộ nhớ
        let (shorter, longer) = s1.count <= s2.count ? (Array(s1), Array(s2)) : (Array(s2), Array(s1))
        let m = shorter.count
        let n = longer.count
        
        // Chỉ cần lưu trữ hai hàng của ma trận thay vì toàn bộ ma trận
        var prevRow = Array(0...m)
        var currRow = Array(repeating: 0, count: m + 1)
        
        for i in 1...n {
            currRow[0] = i
            
            for j in 1...m {
                let cost = longer[i-1] == shorter[j-1] ? 0 : 1
                currRow[j] = min(
                    prevRow[j] + 1,        // Xóa
                    currRow[j-1] + 1,      // Chèn
                    prevRow[j-1] + cost    // Thay thế hoặc giữ nguyên
                )
            }
            
            // Hoán đổi hàng cho lần lặp tiếp theo
            (prevRow, currRow) = (currRow, prevRow)
        }
        
        // Kết quả cuối cùng nằm trong prevRow vì đã hoán đổi ở lần lặp cuối
        return prevRow[m]
    }
}

// MARK: - AVAudioPlayerDelegate
extension JapaneseReadingView: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onPlaybackFinished?()
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            onError?(error)
        }
    }
}
