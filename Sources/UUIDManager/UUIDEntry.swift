import Foundation

struct UUIDEntry: Codable, Identifiable {
    let id: UUID
    let timestamp: Date
    var description: String
    
    init(description: String) {
        self.id = UUID()
        self.timestamp = Date()
        self.description = description
    }
    
    var isCreatedToday: Bool {
        Calendar.current.isDateInToday(timestamp)
    }
    
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: timestamp)
    }
}