import AVFoundation

class AudioUtils: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioUtils()
    
    private var audioPlayer: AVAudioPlayer?
    private var completion: (() -> Void)?

    private override init() {
        super.init()
    }

    // Phát âm thanh từ file
    func playSound(filename: String, fileType: String = "mp3", completion: (() -> Void)? = nil) {
        // Dừng âm thanh đang phát
        stopSound()
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileType) else {
            print("File không tìm thấy: \(filename).\(fileType)")
            completion?()
            return
        }
        
        do {
            // Thiết lập audio session
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            // Tạo và cấu hình audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            if let player = audioPlayer {
                player.delegate = self
                player.prepareToPlay()
                
                // Lưu completion handler
                self.completion = completion
                
                // Kiểm tra và phát
                let playSuccess = player.play()
                
                if !playSuccess {
                    print("Không thể bắt đầu phát âm thanh")
                    completion?()
                } else {
                    print("Đang phát âm thanh: \(filename).\(fileType)")
                }
            } else {
                print("Không thể khởi tạo audio player")
                completion?()
            }
        } catch {
            print("Lỗi khi phát âm thanh: \(error.localizedDescription)")
            completion?()
        }
    }
    
    // Dừng âm thanh
    func stopSound() {
        if let player = audioPlayer, player.isPlaying {
            player.stop()
            self.completion?()
            self.completion = nil
        }
        
        // Giải phóng audio session khi không sử dụng
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
    
    // Kiểm tra xem âm thanh có đang phát hay không
    func isPlaying() -> Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    // Triển khai delegate để xử lý khi phát xong
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio đã phát xong, thành công: \(flag)")
        
        // Gọi completion handler
        self.completion?()
        self.completion = nil
        
        // Giải phóng audio session khi không sử dụng
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
    
    // Xử lý lỗi giải mã âm thanh
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Lỗi giải mã âm thanh: \(error.localizedDescription)")
        }
        
        self.completion?()
        self.completion = nil
    }
}
