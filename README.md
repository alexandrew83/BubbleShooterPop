# Bubble Shooter Pop - iPadOS Game

A classic bubble shooter game built specifically for iPadOS using SwiftUI and SpriteKit.

## Features

### Core Gameplay
- **Classic Bubble Shooter Mechanics**: Aim and shoot bubbles to create matches of 3 or more
- **Hexagonal Grid Layout**: Traditional bubble shooter grid with proper hexagonal positioning
- **Physics-Based Shooting**: Realistic trajectory with wall bouncing
- **Match Detection**: Automatic detection and removal of connected bubbles
- **Floating Bubble Drop**: Unconnected bubbles fall when matches are cleared
- **Progressive Difficulty**: Grid moves down periodically to increase challenge

### Bubble Types
- **6 Standard Colors**: Red, Blue, Green, Yellow, Purple, Orange
- **Special Bubbles** (Framework ready):
  - 💣 Bomb Bubble: Explodes nearby bubbles
  - 🌈 Rainbow Bubble: Matches any color

### Visual Features
- **Stunning Graphics**: Beautiful gradient bubbles with 3D lighting effects
- **Smooth Animations**: SpriteKit-powered animations for bubble movement and effects
- **Trajectory Preview**: Dotted line shows shooting path with wall bounces
- **Responsive UI**: Optimized for iPad screen sizes and orientations
- **Modern Design**: Clean, colorful interface with engaging visual feedback

### Audio & Haptics
- **Sound Effects**: Pop, shoot, match, and special effect sounds
- **Haptic Feedback**: Tactile responses for different game actions
- **Mute Toggle**: Easy audio control
- **System Sound Integration**: Uses iOS system sounds for immediate playability

### Game Modes & Features
- **Score System**: Points for matches with bonus multipliers
- **Shot Counter**: Limited shots before grid advancement
- **Game Over Detection**: Smart detection when bubbles reach the bottom
- **Pause/Resume**: Game state management
- **Reset Functionality**: Easy restart option

### User Interface
- **Intuitive Controls**: Touch to aim and shoot
- **Score Display**: Real-time score tracking
- **Shot Indicator**: Visual representation of remaining shots
- **Next Bubble Preview**: See upcoming bubble color
- **Power-up Slots**: Framework for future power-up features

## Technical Implementation

### Architecture
- **MVVM Pattern**: Clean separation of concerns
- **SwiftUI**: Modern declarative UI framework
- **SpriteKit Integration**: High-performance game rendering
- **Combine Framework**: Reactive programming for game state
- **Observable Objects**: Real-time UI updates

### Performance Optimizations
- **Efficient Collision Detection**: Optimized bubble collision algorithms
- **Memory Management**: Proper cleanup of game objects
- **Smooth 60 FPS**: SpriteKit ensures fluid animations
- **Responsive Touch**: Low-latency input handling

### Code Structure
```
BubbleShooterPop/
├── BubbleShooterPopApp.swift     # App entry point
├── ContentView.swift             # Navigation & game state
├── MenuView.swift                # Main menu interface
├── GameView.swift                # Game UI overlay
├── GameScene.swift               # SpriteKit game scene
├── Bubble.swift                  # Bubble model & view
├── BubbleGrid.swift              # Grid management
├── GameLogic.swift               # Core game mechanics
├── SoundManager.swift            # Audio & haptics
└── Assets.xcassets               # Images & colors
```

## Future Enhancements

### Planned Features
- **Power-ups**: Lightning, Fire, Bomb bubbles with special effects
- **Level System**: Progressive levels with unique layouts
- **Star Rating**: 3-star system based on performance
- **Achievements**: Unlock system for special accomplishments
- **Leaderboards**: Local and global high scores
- **Daily Challenges**: Special puzzle levels
- **Themes**: Different visual themes and bubble designs
- **Multiplayer**: Local and online competitive modes

### Technical Improvements
- **Custom Sound Effects**: Original audio instead of system sounds
- **Particle Effects**: Explosion and magic effects
- **Advanced Physics**: More realistic bubble physics
- **AI Opponents**: Computer players with difficulty levels
- **Cloud Save**: Progress synchronization across devices

## Getting Started

### Requirements
- iOS 17.5+
- iPadOS support (optimized for tablet)
- Xcode 15.4+
- Swift 5.0+

### Installation
1. Open `BubbleShooterPop.xcodeproj` in Xcode
2. Select your target device (iPad simulator recommended)
3. Build and run the project

### Controls
- **Touch and Drag**: Aim the bubble shooter
- **Tap**: Shoot bubble
- **Pause Button**: Pause/resume game
- **Sound Button**: Toggle audio

## Game Rules

1. **Objective**: Clear all bubbles from the screen
2. **Shooting**: Tap to shoot bubbles toward the grid
3. **Matching**: Connect 3+ bubbles of the same color to pop them
4. **Physics**: Bubbles bounce off walls and stick to the grid
5. **Progression**: Grid moves down every 10 shots
6. **Game Over**: When bubbles reach the bottom line

## Credits

Built with ❤️ for iPadOS using:
- SwiftUI for modern iOS development
- SpriteKit for high-performance 2D graphics
- AVFoundation for audio management
- Core Haptics for tactile feedback

---

*Bubble Shooter Pop - The classic game reimagined for modern iPads!*
