import AVFoundation
import SwiftUI

class SoundManager: ObservableObject {
    @Published var isMuted: Bool = false {
        didSet {
            UserDefaults.standard.set(isMuted, forKey: "isMuted")
        }
    }
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    init() {
        isMuted = UserDefaults.standard.bool(forKey: "isMuted")
        setupAudioSession()
        // Note: In a real app, you would load actual sound files here
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func playSound(_ soundName: String) {
        guard !isMuted else { return }
        
        // In a real implementation, you would load actual sound files
        // For now, we'll use system sounds or create simple beeps
        
        switch soundName {
        case "bubble_pop":
            playSystemSound(1104) // Pop sound
        case "bubble_shoot":
            playSystemSound(1306) // Key press sound
        case "match_found":
            playSystemSound(1103) // Success sound
        case "game_over":
            playSystemSound(1107) // Alert sound
        case "power_up":
            playSystemSound(1105) // Special sound
        default:
            playSystemSound(1104) // Default pop sound
        }
    }
    
    private func playSystemSound(_ soundID: SystemSoundID) {
        AudioServicesPlaySystemSound(soundID)
    }
    
    func toggleMute() {
        isMuted.toggle()
    }
    
    func setVolume(_ volume: Float) {
        // Adjust volume for custom sounds (when implemented)
        for (_, player) in audioPlayers {
            player.volume = isMuted ? 0 : volume
        }
    }
    
    // MARK: - Music Management
    
    func playBackgroundMusic() {
        guard !isMuted else { return }
        // TODO: Implement background music
        // In a real implementation, you would load and loop a background music file
    }
    
    func stopBackgroundMusic() {
        // TODO: Stop background music
    }
    
    // MARK: - Haptic Feedback
    
    func playHapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        guard !isMuted else { return }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }
    
    func playSelectionFeedback() {
        guard !isMuted else { return }
        
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
    
    func playNotificationFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard !isMuted else { return }
        
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(type)
    }
}

// MARK: - Sound Effects Extension

extension SoundManager {
    
    func playBubbleShoot() {
        playSound("bubble_shoot")
        playHapticFeedback(.light)
    }
    
    func playBubblePop() {
        playSound("bubble_pop")
        playHapticFeedback(.medium)
    }
    
    func playMatchFound(bubbleCount: Int) {
        if bubbleCount >= 5 {
            playSound("power_up")
            playNotificationFeedback(.success)
        } else {
            playSound("match_found")
            playHapticFeedback(.medium)
        }
    }
    
    func playGameOver() {
        playSound("game_over")
        playNotificationFeedback(.error)
    }
    
    func playMenuSelection() {
        playSelectionFeedback()
    }
    
    func playPowerUpActivated() {
        playSound("power_up")
        playHapticFeedback(.heavy)
    }
}

// MARK: - Audio Settings

struct AudioSettings {
    var masterVolume: Float = 1.0
    var soundEffectsVolume: Float = 1.0
    var musicVolume: Float = 0.7
    var hapticsEnabled: Bool = true
    
    static let shared = AudioSettings()
}

// MARK: - Helper Functions

private func loadAudioFile(named fileName: String, withExtension ext: String) -> AVAudioPlayer? {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: ext) else {
        print("Could not find audio file: \(fileName).\(ext)")
        return nil
    }
    
    do {
        let player = try AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
        return player
    } catch {
        print("Error loading audio file: \(error)")
        return nil
    }
}

// MARK: - Custom Sound Creation (for development)

extension SoundManager {
    
    /// Creates a simple tone for testing purposes
    private func createSimpleTone(frequency: Float, duration: Float) {
        // This is a placeholder for creating simple tones programmatically
        // In a real implementation, you would use AVAudioEngine or similar
        // to generate sounds programmatically if needed
    }
}
