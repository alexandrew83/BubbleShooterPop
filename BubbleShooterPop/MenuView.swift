import SwiftUI

struct MenuView: View {
    let startGame: () -> Void
    
    var body: some View {
        ZStack {
            // Animated background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.4, blue: 0.8),
                    Color(red: 0.6, green: 0.2, blue: 0.8),
                    Color(red: 0.8, green: 0.6, blue: 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Game Title
                VStack(spacing: 10) {
                    Text("BUBBLE")
                        .font(.system(size: 60, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 3, y: 3)
                    
                    Text("SHOOTER")
                        .font(.system(size: 60, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 3, y: 3)
                    
                    Text("POP")
                        .font(.system(size: 60, weight: .black, design: .rounded))
                        .foregroundColor(.yellow)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 3, y: 3)
                }
                
                // Bubble emoji decoration
                HStack(spacing: 20) {
                    Text("🔴")
                        .font(.system(size: 40))
                    Text("🟡")
                        .font(.system(size: 40))
                    Text("🔵")
                        .font(.system(size: 40))
                    Text("🟢")
                        .font(.system(size: 40))
                    Text("🟣")
                        .font(.system(size: 40))
                }
                
                Spacer()
                
                // Start Button
                Button(action: startGame) {
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.title2)
                        Text("START GAME")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(
                        Capsule()
                            .fill(Color.green)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                    )
                }
                .buttonStyle(PressedButtonStyle())
                
                // Additional buttons
                VStack(spacing: 15) {
                    Button("HOW TO PLAY") {
                        // TODO: Show instructions
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Capsule()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    
                    Button("SETTINGS") {
                        // TODO: Show settings
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Capsule()
                            .stroke(Color.white, lineWidth: 2)
                    )
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct PressedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    MenuView(startGame: {})
}
