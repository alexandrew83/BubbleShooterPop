import SpriteKit
import SwiftUI

class GameScene: SKScene {
    var gameLogic: GameLogic?
    var bubbleNodes: [UUID: SKNode] = [:]
    var trajectoryLine: SKShapeNode?
    var shooterBubbleNode: SKNode?
    var nextBubbleNode: SKNode?
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.1, green: 0.2, blue: 0.4, alpha: 1.0)
        setupScene()
    }
    
    func setupScene() {
        // Remove all existing nodes
        removeAllChildren()
        bubbleNodes.removeAll()
        
        // Setup trajectory line
        trajectoryLine = SKShapeNode()
        trajectoryLine?.strokeColor = .white
        trajectoryLine?.lineWidth = 2
        trajectoryLine?.alpha = 0.5
        addChild(trajectoryLine!)
        
        updateBubbleNodes()
        updateShooterBubbles()
    }
    
    func updateBubbleNodes() {
        guard let gameLogic = gameLogic else { return }
        
        // Remove nodes for bubbles that no longer exist
        let existingBubbleIds = Set(gameLogic.grid.bubbles.map { $0.id })
        for (id, node) in bubbleNodes {
            if !existingBubbleIds.contains(id) {
                node.removeFromParent()
                bubbleNodes.removeValue(forKey: id)
            }
        }
        
        // Add or update nodes for existing bubbles
        for bubble in gameLogic.grid.bubbles {
            if let existingNode = bubbleNodes[bubble.id] {
                // Update position
                existingNode.position = CGPoint(x: bubble.position.x, y: size.height - bubble.position.y)
            } else {
                // Create new node
                let bubbleNode = createBubbleNode(for: bubble)
                bubbleNode.position = CGPoint(x: bubble.position.x, y: size.height - bubble.position.y)
                addChild(bubbleNode)
                bubbleNodes[bubble.id] = bubbleNode
            }
        }
    }
    
    func updateShooterBubbles() {
        guard let gameLogic = gameLogic else { return }
        
        // Remove existing shooter bubbles
        shooterBubbleNode?.removeFromParent()
        nextBubbleNode?.removeFromParent()
        
        // Add current bubble
        if let currentBubble = gameLogic.currentBubble {
            shooterBubbleNode = createBubbleNode(for: currentBubble)
            shooterBubbleNode?.position = CGPoint(
                x: currentBubble.position.x,
                y: size.height - currentBubble.position.y
            )
            addChild(shooterBubbleNode!)
        }
        
        // Add next bubble (smaller)
        if let nextBubble = gameLogic.nextBubble {
            nextBubbleNode = createBubbleNode(for: nextBubble)
            nextBubbleNode?.setScale(0.7)
            nextBubbleNode?.position = CGPoint(
                x: nextBubble.position.x + 80,
                y: size.height - nextBubble.position.y
            )
            addChild(nextBubbleNode!)
        }
    }
    
    private func createBubbleNode(for bubble: Bubble) -> SKNode {
        let bubbleNode = SKNode()
        
        // Main circle
        let circle = SKShapeNode(circleOfRadius: gameLogic?.grid.bubbleSize ?? 25)
        circle.fillColor = SKColor(bubble.type.color)
        circle.strokeColor = SKColor(bubble.type.color).withAlphaComponent(0.3)
        circle.lineWidth = 2
        
        // Add gradient effect using multiple circles
        let innerCircle = SKShapeNode(circleOfRadius: (gameLogic?.grid.bubbleSize ?? 25) * 0.7)
        innerCircle.fillColor = SKColor(bubble.type.color).withAlphaComponent(0.8)
        innerCircle.strokeColor = .clear
        
        let highlight = SKShapeNode(circleOfRadius: (gameLogic?.grid.bubbleSize ?? 25) * 0.3)
        highlight.fillColor = SKColor.white.withAlphaComponent(0.4)
        highlight.strokeColor = .clear
        highlight.position = CGPoint(x: -5, y: 5)
        
        bubbleNode.addChild(circle)
        bubbleNode.addChild(innerCircle)
        bubbleNode.addChild(highlight)
        
        // Add special effects for special bubbles
        if bubble.type == .bomb || bubble.type == .rainbow {
            let label = SKLabelNode(text: bubble.type.emoji)
            label.fontSize = (gameLogic?.grid.bubbleSize ?? 25) * 1.2
            label.verticalAlignmentMode = .center
            bubbleNode.addChild(label)
        }
        
        return bubbleNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Convert to game coordinates
        let gameLocation = CGPoint(x: location.x, y: size.height - location.y)
        
        // Shoot bubble
        gameLogic?.shootBubble(towards: gameLocation)
        
        // Update scene
        updateBubbleNodes()
        updateShooterBubbles()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Convert to game coordinates
        let gameLocation = CGPoint(x: location.x, y: size.height - location.y)
        
        // Update trajectory
        gameLogic?.updateTrajectory(targetPoint: gameLocation)
        updateTrajectoryLine()
    }
    
    private func updateTrajectoryLine() {
        guard let gameLogic = gameLogic else { return }
        
        let path = CGMutablePath()
        let points = gameLogic.trajectoryPoints
        
        if !points.isEmpty {
            // Convert to scene coordinates
            let scenePoints = points.map { CGPoint(x: $0.x, y: size.height - $0.y) }
            
            path.move(to: scenePoints[0])
            for point in scenePoints.dropFirst() {
                path.addLine(to: point)
            }
        }
        
        trajectoryLine?.path = path
    }
    
    func animateBubbleRemoval(bubbles: [Bubble]) {
        for bubble in bubbles {
            if let node = bubbleNodes[bubble.id] {
                let scaleAction = SKAction.scale(to: 0, duration: 0.3)
                let fadeAction = SKAction.fadeOut(withDuration: 0.3)
                let groupAction = SKAction.group([scaleAction, fadeAction])
                
                node.run(groupAction) {
                    node.removeFromParent()
                    self.bubbleNodes.removeValue(forKey: bubble.id)
                }
            }
        }
    }
    
    func animateBubbleDrop(bubbles: [Bubble]) {
        for bubble in bubbles {
            if let node = bubbleNodes[bubble.id] {
                let dropAction = SKAction.moveBy(x: 0, y: -size.height, duration: 1.0)
                let rotateAction = SKAction.rotate(byAngle: CGFloat.random(in: -CGFloat.pi...CGFloat.pi), duration: 1.0)
                let groupAction = SKAction.group([dropAction, rotateAction])
                
                node.run(groupAction) {
                    node.removeFromParent()
                    self.bubbleNodes.removeValue(forKey: bubble.id)
                }
            }
        }
    }
}

// SwiftUI wrapper for SpriteKit scene
struct GameSceneView: UIViewRepresentable {
    @ObservedObject var gameLogic: GameLogic
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.showsFPS = false
        view.showsNodeCount = false
        view.ignoresSiblingOrder = true
        
        let scene = GameScene()
        scene.gameLogic = gameLogic
        scene.size = CGSize(width: 400, height: 800)
        scene.scaleMode = .aspectFit
        
        view.presentScene(scene)
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        if let scene = uiView.scene as? GameScene {
            scene.gameLogic = gameLogic
            scene.updateBubbleNodes()
            scene.updateShooterBubbles()
        }
    }
}
