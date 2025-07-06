import SwiftUI

enum GameState {
    case menu
    case playing
    case paused
    case gameOver
}

struct ContentView: View {
    @State private var gameState: GameState = .menu
    
    var body: some View {
        switch gameState {
        case .menu:
            MenuView(startGame: {
                gameState = .playing
            })
        case .playing:
            GameView(
                pauseGame: { gameState = .paused },
                endGame: { gameState = .gameOver },
                returnToMenu: { gameState = .menu }
            )
        case .paused:
            PauseView(
                resumeGame: { gameState = .playing },
                returnToMenu: { gameState = .menu }
            )
        case .gameOver:
            GameOverView(
                playAgain: { gameState = .playing },
                returnToMenu: { gameState = .menu }
            )
        }
    }
}

struct PauseView: View {
    let resumeGame: () -> Void
    let returnToMenu: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("PAUSED")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Button("Resume") {
                    resumeGame()
                }
                .font(.title2)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(15)
                
                Button("Menu") {
                    returnToMenu()
                }
                .font(.title2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
        }
    }
}

struct GameOverView: View {
    let playAgain: () -> Void
    let returnToMenu: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("GAME OVER")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("🎮")
                    .font(.system(size: 80))
                
                Button("Play Again") {
                    playAgain()
                }
                .font(.title2)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(15)
                
                Button("Menu") {
                    returnToMenu()
                }
                .font(.title2)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
        }
    }
}

#Preview {
    ContentView()
}
