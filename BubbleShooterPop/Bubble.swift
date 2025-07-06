import SwiftUI
import Foundation

enum BubbleType: CaseIterable {
    case red
    case blue
    case green
    case yellow
    case purple
    case orange
    case bomb
    case rainbow
    
    var color: Color {
        switch self {
        case .red:
            return .red
        case .blue:
            return .blue
        case .green:
            return .green
        case .yellow:
            return .yellow
        case .purple:
            return .purple
        case .orange:
            return .orange
        case .bomb:
            return .black
        case .rainbow:
            return .white
        }
    }
    
    var emoji: String {
        switch self {
        case .red:
            return "🔴"
        case .blue:
            return "🔵"
        case .green:
            return "🟢"
        case .yellow:
            return "🟡"
        case .purple:
            return "🟣"
        case .orange:
            return "🟠"
        case .bomb:
            return "💣"
        case .rainbow:
            return "🌈"
        }
    }
    
    static var normalTypes: [BubbleType] {
        return [.red, .blue, .green, .yellow, .purple, .orange]
    }
}

struct Bubble: Identifiable, Equatable {
    let id = UUID()
    var type: BubbleType
    var position: CGPoint
    var isConnected: Bool = false
    var isMatched: Bool = false
    var velocity: CGPoint = .zero
    
    init(type: BubbleType, position: CGPoint) {
        self.type = type
        self.position = position
    }
    
    static func == (lhs: Bubble, rhs: Bubble) -> Bool {
        return lhs.id == rhs.id
    }
    
    func distance(to other: Bubble) -> CGFloat {
        let dx = position.x - other.position.x
        let dy = position.y - other.position.y
        return sqrt(dx * dx + dy * dy)
    }
    
    func isAdjacent(to other: Bubble, bubbleSize: CGFloat) -> Bool {
        let distance = distance(to: other)
        return distance <= bubbleSize * 1.1 // Small tolerance for floating point precision
    }
}

struct BubbleView: View {
    let bubble: Bubble
    let size: CGFloat
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Main bubble circle
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            bubble.type.color.opacity(0.8),
                            bubble.type.color
                        ]),
                        center: .topLeading,
                        startRadius: size * 0.1,
                        endRadius: size * 0.7
                    )
                )
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .stroke(bubble.type.color.opacity(0.3), lineWidth: 2)
                )
            
            // Highlight for 3D effect
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.6),
                            Color.clear
                        ]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size * 0.3
                    )
                )
                .frame(width: size * 0.4, height: size * 0.4)
                .offset(x: -size * 0.15, y: -size * 0.15)
            
            // Emoji overlay for special bubbles
            if bubble.type == .bomb || bubble.type == .rainbow {
                Text(bubble.type.emoji)
                    .font(.system(size: size * 0.6))
            }
        }
        .scaleEffect(bubble.isMatched ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: bubble.isMatched)
        .offset(y: animationOffset)
        .onAppear {
            // Floating animation for special bubbles
            if bubble.type == .rainbow {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    animationOffset = -5
                }
            }
        }
    }
}

#Preview {
    VStack {
        HStack {
            BubbleView(bubble: Bubble(type: .red, position: .zero), size: 60)
            BubbleView(bubble: Bubble(type: .blue, position: .zero), size: 60)
            BubbleView(bubble: Bubble(type: .green, position: .zero), size: 60)
        }
        HStack {
            BubbleView(bubble: Bubble(type: .yellow, position: .zero), size: 60)
            BubbleView(bubble: Bubble(type: .purple, position: .zero), size: 60)
            BubbleView(bubble: Bubble(type: .orange, position: .zero), size: 60)
        }
        HStack {
            BubbleView(bubble: Bubble(type: .bomb, position: .zero), size: 60)
            BubbleView(bubble: Bubble(type: .rainbow, position: .zero), size: 60)
        }
    }
    .padding()
}
