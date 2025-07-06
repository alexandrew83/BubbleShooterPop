import SwiftUI

struct GameView: View {
    @StateObject private var gameLogic = GameLogic()
    @StateObject private var soundManager = SoundManager()
    
    let pauseGame: () -> Void
    let endGame: () -> Void
    let returnToMenu: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.2, blue: 0.4),
                        Color(red: 0.2, green: 0.3, blue: 0.6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top UI Bar
                    HStack {
                        // Score
                        VStack(alignment: .leading) {
                            Text("SCORE")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            Text("\(gameLogic.score)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Shots remaining
                        VStack {
                            Text("SHOTS")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            HStack(spacing: 4) {
                                ForEach(0..<gameLogic.shotsRemaining, id: \.self) { _ in
                                    Circle()
                                        .fill(Color.yellow)
                                        .frame(width: 8, height: 8)
                                }
                                ForEach(gameLogic.shotsRemaining..<10, id: \.self) { _ in
                                    Circle()
                                        .fill(Color.white.opacity(0.3))
                                        .frame(width: 8, height: 8)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Pause button
                        Button(action: pauseGame) {
                            Image(systemName: "pause.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Circle().fill(Color.black.opacity(0.3)))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Game Scene
                    GameSceneView(gameLogic: gameLogic)
                        .frame(
                            width: min(geometry.size.width, 400),
                            height: geometry.size.height * 0.8
                        )
                        .clipped()
                    
                    // Bottom UI
                    HStack {
                        // Next bubble preview
                        VStack {
                            Text("NEXT")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.8))
                            
                            if let nextBubble = gameLogic.nextBubble {
                                BubbleView(bubble: nextBubble, size: 40)
                            }
                        }
                        
                        Spacer()
                        
                        // Power-ups (future feature)
                        HStack(spacing: 15) {
                            PowerUpButton(
                                icon: "target",
                                isEnabled: false,
                                action: { /* TODO: Implement aim assist */ }
                            )
                            PowerUpButton(
                                icon: "bolt.fill",
                                isEnabled: false,
                                action: { /* TODO: Implement lightning bubble */ }
                            )
                            PowerUpButton(
                                icon: "flame.fill",
                                isEnabled: false,
                                action: { /* TODO: Implement fire bubble */ }
                            )
                        }
                        
                        Spacer()
                        
                        // Settings
                        Button(action: {
                            soundManager.toggleMute()
                        }) {
                            Image(systemName: soundManager.isMuted ? "speaker.slash.fill" : "speaker.2.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Circle().fill(Color.black.opacity(0.3)))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Game Over Overlay
                if gameLogic.isGameOver {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture {
                            endGame()
                        }
                    
                    VStack(spacing: 20) {
                        Text("GAME OVER!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Final Score: \(gameLogic.score)")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 20) {
                            Button("Play Again") {
                                gameLogic.resetGame()
                            }
                            .font(.title3)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            
                            Button("Menu") {
                                returnToMenu()
                            }
                            .font(.title3)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            gameLogic.resetGame()
        }
    }
}

struct PowerUpButton: View {
    let icon: String
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isEnabled ? .yellow : .white.opacity(0.5))
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(isEnabled ? Color.orange.opacity(0.8) : Color.black.opacity(0.3))
                )
        }
        .disabled(!isEnabled)
    }
}

struct BubbleTrajectoryView: View {
    let points: [CGPoint]
    
    var body: some View {
        Path { path in
            guard !points.isEmpty else { return }
            
            path.move(to: points.first!)
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
        }
        .stroke(Color.white.opacity(0.6), style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
    }
}

#Preview {
    GameView(
        pauseGame: {},
        endGame: {},
        returnToMenu: {}
    )
}
