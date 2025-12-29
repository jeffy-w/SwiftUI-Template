import Foundation
import Observation

@MainActor
@Observable
public final class PomodoroFeature {
    public enum SessionType: String, CaseIterable, Identifiable {
        case focus = "Focus"
        case shortBreak = "Short Break"
        case longBreak = "Long Break"
        
        public var id: String { rawValue }
        
        public var duration: TimeInterval {
            switch self {
            case .focus: return 25 * 60
            case .shortBreak: return 5 * 60
            case .longBreak: return 15 * 60
            }
        }
        
        public var icon: String {
            switch self {
            case .focus: return "brain.head.profile"
            case .shortBreak: return "cup.and.saucer"
            case .longBreak: return "bed.double"
            }
        }
    }
    
    public var selectedSession: SessionType = .focus {
        didSet {
            reset()
        }
    }
    
    public var timeRemaining: TimeInterval
    public var isActive: Bool = false
    public var totalDuration: TimeInterval
    
    private var timer: Timer?
    
    public init() {
        self.timeRemaining = SessionType.focus.duration
        self.totalDuration = SessionType.focus.duration
    }
    
    public var progress: Double {
        guard totalDuration > 0 else { return 0 }
        return 1 - (timeRemaining / totalDuration)
    }
    
    public var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    public func toggleTimer() {
        if isActive {
            pause()
        } else {
            start()
        }
    }
    
    public func start() {
        guard !isActive else { return }
        isActive = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.isActive = false
                    self.timer?.invalidate()
                    self.timer = nil
                }
            }
        }
    }
    
    public func pause() {
        isActive = false
        timer?.invalidate()
        timer = nil
    }
    
    public func reset() {
        pause()
        totalDuration = selectedSession.duration
        timeRemaining = totalDuration
    }
}
