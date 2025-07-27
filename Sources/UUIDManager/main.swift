import Foundation
import ArgumentParser

struct UUIDManager: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "uuid-manager",
        abstract: "A command-line UUID manager with interactive interface"
    )
    
    func run() throws {
        let app = try App()
        try runInteractiveMode(app: app)
    }
}

UUIDManager.main()

func runInteractiveMode(app: App) throws {
    print("Welcome to UUID Manager!")
    print("Commands: (n)ew, (l)ist, (d)elete, (c)opy, (q)uit")
    print("")
    
    while true {
        displayUI(app: app)
        
        if let input = readInput() {
            let handled = try handleInput(input, app: app)
            if !handled {
                break
            }
        }
    }
}

func displayUI(app: App) {
    print("\n" + String(repeating: "=", count: 80))
    print("                            UUID Manager")
    print(String(repeating: "=", count: 80))
    
    if app.uuidEntries.isEmpty {
        print("No UUIDs stored. Press 'n' to create a new one.")
    } else {
        print("UUIDs (\(app.uuidEntries.count) total):")
        for (index, entry) in app.uuidEntries.enumerated() {
            let marker = (app.selectedIndex == index) ? "► " : "  "
            let color = entry.isCreatedToday ? "\u{1B}[32m" : "\u{1B}[37m"
            let resetColor = "\u{1B}[0m"
            
            let description = entry.description.isEmpty ? "" : " - \(entry.description)"
            print("\(marker)\(index): \(color)\(entry.id.uuidString)\(resetColor) (\(entry.formattedTimestamp))\(description)")
        }
    }
    
    print("")
    
    switch app.inputMode {
    case .normal:
        print("Commands: (n)ew UUID, (i)nput mode, (d)elete, (c)opy, up/down navigate, (q)uit")
    case .editing:
        print("Editing mode - Enter description: \(app.input)")
        print("Press Enter to save, type 'cancel' to cancel")
    }
    
    print("")
    print("Enter command: ", terminator: "")
}

func readInput() -> String? {
    guard let input = readLine() else { return nil }
    return input.trimmingCharacters(in: .whitespacesAndNewlines)
}

func handleInput(_ input: String, app: App) throws -> Bool {
    switch app.inputMode {
    case .normal:
        return try handleNormalModeInput(input, app: app)
    case .editing:
        return try handleEditingModeInput(input, app: app)
    }
}

func handleNormalModeInput(_ input: String, app: App) throws -> Bool {
    switch input.lowercased() {
    case "q", "quit":
        return false
        
    case "n", "new":
        try app.addEntry(description: "")
        print("New UUID created!")
        Thread.sleep(forTimeInterval: 1)
        
    case "i", "input":
        if app.selectedIndex != nil {
            app.toggleInputMode()
        } else {
            print("Error: No UUID selected. Select a UUID first before entering input mode.")
            Thread.sleep(forTimeInterval: 2)
        }
        
    case "d", "delete":
        if app.deleteSelectedEntry() {
            print("UUID deleted!")
        } else {
            print("No UUID selected or error occurred!")
        }
        Thread.sleep(forTimeInterval: 1)
        
    case "c", "copy":
        do {
            let filePath = try app.copySelectedUUID()
            print("UUID copied to: \(filePath)")
        } catch {
            print("Error copying UUID: \(error)")
        }
        Thread.sleep(forTimeInterval: 1)
        
    case "up":
        app.previousEntry()
        
    case "down":
        app.nextEntry()
        
    case "l", "list":
        break
        
    default:
        if let index = Int(input), index >= 0 && index < app.uuidEntries.count {
            app.selectedIndex = index
        } else {
            print("Unknown command: \(input)")
            Thread.sleep(forTimeInterval: 1)
        }
    }
    
    return true
}

func handleEditingModeInput(_ input: String, app: App) throws -> Bool {
    if input.lowercased() == "cancel" {
        app.input = ""
        app.toggleInputMode()
        print("Input cancelled.")
        Thread.sleep(forTimeInterval: 1)
    } else if input.isEmpty {
        let description = app.input
        try app.updateSelectedEntryDescription(description)
        app.input = ""
        app.toggleInputMode()
        print("Description updated!")
        Thread.sleep(forTimeInterval: 1)
    } else {
        app.input = input
    }
    
    return true
}