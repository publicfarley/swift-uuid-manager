import Foundation

struct Storage {
    private let dataPath: URL
    
    init() throws {
        let fileManager = FileManager.default
        let dataDirectory = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent("uuid-manager", isDirectory: true)
        
        if !fileManager.fileExists(atPath: dataDirectory.path) {
            try fileManager.createDirectory(
                at: dataDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        
        self.dataPath = dataDirectory.appendingPathComponent("uuids.json")
    }
    
    func load() throws -> [UUIDEntry] {
        guard FileManager.default.fileExists(atPath: dataPath.path) else {
            return []
        }
        
        let data = try Data(contentsOf: dataPath)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode([UUIDEntry].self, from: data)
    }
    
    func save(_ entries: [UUIDEntry]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try encoder.encode(entries)
        try data.write(to: dataPath)
    }
}