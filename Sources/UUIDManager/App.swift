import Foundation

enum InputMode {
    case normal
    case editing
}

class App {
    var uuidEntries: [UUIDEntry] = []
    var input: String = ""
    var inputMode: InputMode = .normal
    var selectedIndex: Int? = nil
    private let storage: Storage
    
    init() throws {
        self.storage = try Storage()
        loadEntries()
    }
    
    private func loadEntries() {
        do {
            uuidEntries = try storage.load()
            sortEntries()
        } catch {
            print("Error loading UUIDs: \(error)")
        }
    }
    
    func addEntry(description: String) throws {
        let entry = UUIDEntry(description: description)
        uuidEntries.append(entry)
        sortEntries()
        try storage.save(uuidEntries)
    }
    
    func sortEntries() {
        uuidEntries.sort { $0.timestamp > $1.timestamp }
    }
    
    func toggleInputMode() {
        inputMode = inputMode == .normal ? .editing : .normal
    }
    
    func nextEntry() {
        guard !uuidEntries.isEmpty else { return }
        
        if let index = selectedIndex {
            selectedIndex = index < uuidEntries.count - 1 ? index + 1 : index
        } else {
            selectedIndex = 0
        }
    }
    
    func previousEntry() {
        guard !uuidEntries.isEmpty else { return }
        
        if let index = selectedIndex {
            selectedIndex = index > 0 ? index - 1 : index
        } else {
            selectedIndex = uuidEntries.count - 1
        }
    }
    
    @discardableResult
    func deleteSelectedEntry() -> Bool {
        guard let index = selectedIndex, index < uuidEntries.count else {
            return false
        }
        
        uuidEntries.remove(at: index)
        
        if uuidEntries.isEmpty {
            selectedIndex = nil
        } else if index >= uuidEntries.count {
            selectedIndex = uuidEntries.count - 1
        }
        
        do {
            try storage.save(uuidEntries)
            return true
        } catch {
            print("Error saving UUIDs: \(error)")
            return false
        }
    }
    
    func copySelectedUUID() throws -> String {
        guard let index = selectedIndex, index < uuidEntries.count else {
            throw NSError(domain: "UUIDManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "No UUID selected"])
        }
        
        let uuidString = uuidEntries[index].id.uuidString
        let tempFile = "/tmp/uuid_manager_copy.txt"
        
        try uuidString.write(toFile: tempFile, atomically: true, encoding: .utf8)
        return tempFile
    }
}