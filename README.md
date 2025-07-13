# iOS Video Player

A SwiftUI-based iOS video player application designed for language learning, featuring custom controls and an intuitive interface.

## Features

### Core Functionality

- **Video List**:  
  Browse language learning videos with thumbnails and details
- **Custom Video Player**:  
  AVFoundation-based player with custom controls
- **Favorites System**:  
  Heart videos to save them for later viewing

### Player Controls

- **Playback Speed Control**:  
  0.5x, 1.0x, 1.5x, 2.0x speed options with visual picker
- **Skip Controls**:  
  Quick 10-second forward/backward navigation
- **Progress Bar**:  
  Drag to seek with smooth seeking experience and loading indicator
- **Auto-hiding Controls**:  
  Controls fade after 5 seconds of inactivity

## Requirements

- iOS 17.0+

## Technical Implementation

- **MVVM Architecture**:  
  Clean separation with ViewModels managing business logic
- **SwiftUI + Combine**:  
  Reactive UI with declarative state management
- **AVFoundation Integration**:  
  Custom video player with precise playback control
- **URLCache System**:  
  Efficient image caching for smooth scrolling performance
- **UserDefaults Persistence**:  
  Lightweight favorite state management
- **Unit Testing**:  
  Unit tests covering playback controls and boundary conditions
- **Dark Mode Support**:  
  Automatic theme adaptation
