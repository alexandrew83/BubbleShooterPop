import SwiftUI
import Foundation

class BubbleGrid: ObservableObject {
    @Published var bubbles: [Bubble] = []
    
    let rows: Int = 12
    let columns: Int = 8
    let bubbleSize: CGFloat = 40
    let spacing: CGFloat = 2
    
    private var gridWidth: CGFloat {
        CGFloat(columns) * (bubbleSize + spacing) - spacing
    }
    
    init() {
        generateInitialGrid()
    }
    
    func generateInitialGrid() {
        bubbles.removeAll()
        
        let gameWidth: CGFloat = 400
        let startX: CGFloat = (gameWidth - gridWidth) / 2
        
        // Generate initial 6 rows of bubbles
        for row in 0..<6 {
            let isEvenRow = row % 2 == 0
            let bubblesInRow = isEvenRow ? columns : columns - 1
            let offsetX: CGFloat = isEvenRow ? 0 : (bubbleSize + spacing) / 2
            
            for col in 0..<bubblesInRow {
                let x = startX + offsetX + CGFloat(col) * (bubbleSize + spacing) + bubbleSize / 2
                let y = CGFloat(row) * (bubbleSize * 0.866 + spacing) + bubbleSize / 2 + 50
                
                let randomType = BubbleType.normalTypes.randomElement() ?? .red
                let bubble = Bubble(type: randomType, position: CGPoint(x: x, y: y))
                bubbles.append(bubble)
            }
        }
    }
    
    func addBubble(_ bubble: Bubble) {
        bubbles.append(bubble)
    }
    
    func removeBubbles(_ bubblesToRemove: [Bubble]) {
        for bubbleToRemove in bubblesToRemove {
            bubbles.removeAll { $0.id == bubbleToRemove.id }
        }
    }
    
    func getBubblesAt(position: CGPoint, radius: CGFloat) -> [Bubble] {
        return bubbles.filter { bubble in
            let distance = sqrt(pow(bubble.position.x - position.x, 2) + pow(bubble.position.y - position.y, 2))
            return distance <= radius
        }
    }
    
    func getNearestValidPosition(for point: CGPoint) -> CGPoint {
        // Find the closest grid position
        let row = Int((point.y - bubbleSize / 2) / (bubbleSize * 0.866 + spacing))
        let isEvenRow = row % 2 == 0
        let offsetX: CGFloat = isEvenRow ? 0 : (bubbleSize + spacing) / 2
        
        let col = Int((point.x - offsetX - bubbleSize / 2) / (bubbleSize + spacing))
        let clampedCol = max(0, min(col, isEvenRow ? columns - 1 : columns - 2))
        
        let x = offsetX + CGFloat(clampedCol) * (bubbleSize + spacing) + bubbleSize / 2
        let y = CGFloat(row) * (bubbleSize * 0.866 + spacing) + bubbleSize / 2
        
        return CGPoint(x: x, y: y)
    }
    
    func findConnectedBubbles(of type: BubbleType, startingFrom bubble: Bubble) -> Set<Bubble> {
        var connectedBubbles: Set<Bubble> = []
        var toVisit: [Bubble] = [bubble]
        
        while !toVisit.isEmpty {
            let currentBubble = toVisit.removeFirst()
            
            if connectedBubbles.contains(currentBubble) {
                continue
            }
            
            if currentBubble.type == type || type == .rainbow {
                connectedBubbles.insert(currentBubble)
                
                // Find adjacent bubbles
                let adjacentBubbles = bubbles.filter { otherBubble in
                    otherBubble.id != currentBubble.id &&
                    !connectedBubbles.contains(otherBubble) &&
                    currentBubble.isAdjacent(to: otherBubble, bubbleSize: bubbleSize)
                }
                
                toVisit.append(contentsOf: adjacentBubbles)
            }
        }
        
        return connectedBubbles
    }
    
    func findFloatingBubbles() -> Set<Bubble> {
        var connectedToTop: Set<Bubble> = []
        var toVisit: [Bubble] = []
        
        // Start with bubbles in the top row
        let topRowBubbles = bubbles.filter { $0.position.y <= bubbleSize }
        toVisit.append(contentsOf: topRowBubbles)
        
        while !toVisit.isEmpty {
            let currentBubble = toVisit.removeFirst()
            
            if connectedToTop.contains(currentBubble) {
                continue
            }
            
            connectedToTop.insert(currentBubble)
            
            // Find adjacent bubbles
            let adjacentBubbles = bubbles.filter { otherBubble in
                otherBubble.id != currentBubble.id &&
                !connectedToTop.contains(otherBubble) &&
                currentBubble.isAdjacent(to: otherBubble, bubbleSize: bubbleSize)
            }
            
            toVisit.append(contentsOf: adjacentBubbles)
        }
        
        // Return bubbles that are not connected to the top
        return Set(bubbles.filter { !connectedToTop.contains($0) })
    }
    
    func moveGridDown() {
        for i in 0..<bubbles.count {
            bubbles[i].position.y += bubbleSize * 0.866 + spacing
        }
        
        // Add a new row at the top
        addNewTopRow()
    }
    
    private func addNewTopRow() {
        let gameWidth: CGFloat = 400
        let startX: CGFloat = (gameWidth - gridWidth) / 2
        let newRow = 0 // Always add to top
        let isEvenRow = newRow % 2 == 0
        let bubblesInRow = isEvenRow ? columns : columns - 1
        let offsetX: CGFloat = isEvenRow ? 0 : (bubbleSize + spacing) / 2
        
        for col in 0..<bubblesInRow {
            let x = startX + offsetX + CGFloat(col) * (bubbleSize + spacing) + bubbleSize / 2
            let y = CGFloat(newRow) * (bubbleSize * 0.866 + spacing) + bubbleSize / 2 + 50
            
            let randomType = BubbleType.normalTypes.randomElement() ?? .red
            let bubble = Bubble(type: randomType, position: CGPoint(x: x, y: y))
            bubbles.append(bubble)
        }
    }
    
    func getGameBounds() -> CGRect {
        return CGRect(
            x: 0,
            y: 0,
            width: 400, // Fixed width for iPad
            height: 600  // Fixed height for game area
        )
    }
}

