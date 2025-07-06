import SwiftUI
import Foundation

class GameLogic: ObservableObject {
    @Published var grid = BubbleGrid()
    @Published var score: Int = 0
    @Published var currentBubble: Bubble?
    @Published var nextBubble: Bubble?
    @Published var shotsRemaining: Int = 10
    @Published var isGameOver: Bool = false
    @Published var trajectoryPoints: [CGPoint] = []
    
    private let minMatchSize = 3
    private let scorePerBubble = 10
    private let bonusMultiplier = 2
    
    init() {
        generateNextBubbles()
    }
    
    func generateNextBubbles() {
        currentBubble = Bubble(
            type: BubbleType.normalTypes.randomElement() ?? .red,
            position: CGPoint(x: grid.getGameBounds().width / 2, y: grid.getGameBounds().height - 100)
        )
        nextBubble = Bubble(
            type: BubbleType.normalTypes.randomElement() ?? .red,
            position: CGPoint(x: grid.getGameBounds().width / 2, y: grid.getGameBounds().height - 50)
        )
    }
    
    func shootBubble(towards point: CGPoint) {
        guard let bubble = currentBubble, shotsRemaining > 0 else { return }
        
        // Calculate trajectory
        let startPoint = bubble.position
        let direction = CGPoint(
            x: point.x - startPoint.x,
            y: point.y - startPoint.y
        )
        let length = sqrt(direction.x * direction.x + direction.y * direction.y)
        let normalizedDirection = CGPoint(
            x: direction.x / length,
            y: direction.y / length
        )
        
        // Simulate bubble movement
        var currentPosition = startPoint
        let speed: CGFloat = 10
        var finalPosition: CGPoint?
        
        // Basic trajectory simulation (you might want to make this more sophisticated)
        while currentPosition.y > 0 && finalPosition == nil {
            currentPosition.x += normalizedDirection.x * speed
            currentPosition.y += normalizedDirection.y * speed
            
            // Check for collision with existing bubbles
            let nearbyBubbles = grid.getBubblesAt(position: currentPosition, radius: grid.bubbleSize)
            if !nearbyBubbles.isEmpty {
                finalPosition = grid.getNearestValidPosition(for: currentPosition)
                break
            }
            
            // Check for wall collision
            if currentPosition.x <= grid.bubbleSize / 2 || 
               currentPosition.x >= grid.getGameBounds().width - grid.bubbleSize / 2 {
                // Bounce off wall
                normalizedDirection = CGPoint(x: -normalizedDirection.x, y: normalizedDirection.y)
            }
            
            // Check if reached top
            if currentPosition.y <= grid.bubbleSize / 2 {
                finalPosition = grid.getNearestValidPosition(for: currentPosition)
                break
            }
        }
        
        if let finalPos = finalPosition {
            // Add bubble to grid
            let newBubble = Bubble(type: bubble.type, position: finalPos)
            grid.addBubble(newBubble)
            
            // Check for matches
            processMatches(startingBubble: newBubble)
            
            // Move to next bubble
            currentBubble = nextBubble
            generateNextBubbles()
            
            shotsRemaining -= 1
            
            // Check if shots remaining reached zero
            if shotsRemaining <= 0 {
                grid.moveGridDown()
                shotsRemaining = 10
            }
            
            // Check for game over conditions
            checkGameOver()
        }
    }
    
    private func processMatches(startingBubble: Bubble) {
        let matchedBubbles = grid.findConnectedBubbles(of: startingBubble.type, startingFrom: startingBubble)
        
        if matchedBubbles.count >= minMatchSize {
            // Remove matched bubbles
            grid.removeBubbles(Array(matchedBubbles))
            
            // Calculate score
            let baseScore = matchedBubbles.count * scorePerBubble
            score += baseScore
            
            // Find and remove floating bubbles
            let floatingBubbles = grid.findFloatingBubbles()
            if !floatingBubbles.isEmpty {
                grid.removeBubbles(Array(floatingBubbles))
                // Bonus points for floating bubbles
                score += floatingBubbles.count * scorePerBubble * bonusMultiplier
            }
        }
    }
    
    private func checkGameOver() {
        // Check if any bubble has reached the bottom
        let bottomThreshold = grid.getGameBounds().height - 150
        let bubblesNearBottom = grid.bubbles.filter { $0.position.y >= bottomThreshold }
        
        if !bubblesNearBottom.isEmpty {
            isGameOver = true
        }
    }
    
    func calculateTrajectory(from start: CGPoint, to target: CGPoint) -> [CGPoint] {
        var points: [CGPoint] = []
        let direction = CGPoint(
            x: target.x - start.x,
            y: target.y - start.y
        )
        let length = sqrt(direction.x * direction.x + direction.y * direction.y)
        let normalizedDirection = CGPoint(
            x: direction.x / length,
            y: direction.y / length
        )
        
        var currentPos = start
        let step: CGFloat = 20
        var bounces = 0
        let maxBounces = 3
        
        while currentPos.y > 0 && bounces <= maxBounces && points.count < 50 {
            points.append(currentPos)
            
            currentPos.x += normalizedDirection.x * step
            currentPos.y += normalizedDirection.y * step
            
            // Check for wall bounces
            if currentPos.x <= grid.bubbleSize / 2 || 
               currentPos.x >= grid.getGameBounds().width - grid.bubbleSize / 2 {
                normalizedDirection = CGPoint(x: -normalizedDirection.x, y: normalizedDirection.y)
                bounces += 1
            }
        }
        
        return points
    }
    
    func updateTrajectory(targetPoint: CGPoint) {
        guard let bubble = currentBubble else { return }
        trajectoryPoints = calculateTrajectory(from: bubble.position, to: targetPoint)
    }
    
    func resetGame() {
        grid = BubbleGrid()
        score = 0
        shotsRemaining = 10
        isGameOver = false
        trajectoryPoints = []
        generateNextBubbles()
    }
}

// Game statistics for tracking player progress
struct GameStats {
    var highScore: Int = 0
    var gamesPlayed: Int = 0
    var totalBubblesPopped: Int = 0
    var averageScore: Double {
        return gamesPlayed > 0 ? Double(totalBubblesPopped) / Double(gamesPlayed) : 0
    }
}
