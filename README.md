# UUID Manager - Swift Edition

A command-line UUID manager with interactive interface, inspired by the Rust implementation.

## Features

- **Generate UUIDs**: Create new UUIDs with optional descriptions
- **Persistent Storage**: UUIDs are saved to JSON file in user's Application Support directory
- **Interactive Interface**: Simple command-line interface for UUID management
- **UUID Selection**: Navigate through UUIDs with arrow keys or number selection
- **Copy to File**: Copy selected UUID to temporary file for easy access
- **Visual Indicators**: Today's UUIDs are highlighted in green

## Installation

### Prerequisites

- Swift 5.9 or later
- macOS 10.15 or later

### Build from Source

```bash
cd swift/uuid-manager
swift build
```

### Run

```bash
# Development build
./.build/debug/uuid-manager

# Release build (faster)
swift build -c release
./.build/release/uuid-manager
```

## Usage

When you run the application, you'll see an interactive interface with the following commands:

- **n** or **new**: Generate a new UUID
- **i** or **input**: Enter input mode to add a description
- **d** or **delete**: Delete the selected UUID
- **c** or **copy**: Copy selected UUID to `/tmp/uuid_manager_copy.txt`
- **l** or **list**: Refresh the display
- **↑** or **up**: Select previous UUID
- **↓** or **down**: Select next UUID
- **0-9**: Select UUID by index number
- **q** or **quit**: Exit the application

### Input Mode

When in input mode (press 'i'):
- Type a description for your UUID
- Press **Enter** to create the UUID with description
- Press **Esc** to cancel and return to normal mode

## Architecture

The Swift implementation follows the same modular architecture as the Rust version:

### Core Components

- **UUIDEntry.swift**: Core data structure with UUID, timestamp, and description
- **Storage.swift**: JSON-based persistence to Application Support directory
- **App.swift**: Application state management and business logic
- **main.swift**: Command-line interface and user interaction

### Key Features

- **Automatic Persistence**: All changes are immediately saved to disk
- **Date Formatting**: Human-readable timestamps for all UUIDs
- **Error Handling**: Graceful error handling with user feedback
- **Clean Architecture**: Separation of concerns between UI, logic, and storage

## Storage Location

UUIDs are stored in:
```
~/Library/Application Support/uuid-manager/uuids.json
```

## Dependencies

- **Swift ArgumentParser**: Command-line argument parsing (not heavily used in interactive mode)
- **Foundation**: Core Swift framework for UUID generation, JSON handling, and file operations

## Development

### Project Structure

```
Sources/
└── UUIDManager/
    ├── UUIDEntry.swift    # Data model
    ├── Storage.swift      # Persistence layer
    ├── App.swift          # Application logic
    └── main.swift         # CLI interface
```

### Building and Testing

```bash
# Clean build
swift package clean
swift build

# Run directly
swift run

# Generate Xcode project (optional)
swift package generate-xcodeproj
```

## Comparison with Rust Version

This Swift implementation provides the same core functionality as the Rust version:

- ✅ UUID generation with descriptions
- ✅ JSON persistence
- ✅ Interactive command-line interface
- ✅ UUID selection and navigation
- ✅ Copy functionality
- ✅ Date-based visual indicators
- ✅ Error handling and recovery

### Differences

- **UI Framework**: Uses simple console output instead of Ratatui TUI framework
- **Input Handling**: Line-based input instead of real-time key capture
- **Platform**: macOS-focused (Application Support directory)
- **Dependencies**: Minimal dependencies (just ArgumentParser)

## License

This project follows the same license as the original Rust implementation.