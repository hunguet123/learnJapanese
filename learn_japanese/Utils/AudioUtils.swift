//
//  AudioUtils.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 12/2/25.
//
import AVFoundation

class AudioUtils {
    static let shared = AudioUtils()
    
    private var audioPlayer: AVAudioPlayer?

    private init() {}

    // Phát âm thanh từ file
    func playSound(filename: String, fileType: String = "mp3") {
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileType) else {
            print("File không tìm thấy: \(filename).\(fileType)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Lỗi khi phát âm thanh: \(error.localizedDescription)")
        }
    }
    
    // Dừng âm thanh
    func stopSound() {
        audioPlayer?.stop()
    }
    
    // Kiểm tra xem âm thanh có đang phát hay không
    func isPlaying() -> Bool {
        return audioPlayer?.isPlaying ?? false
    }
}

